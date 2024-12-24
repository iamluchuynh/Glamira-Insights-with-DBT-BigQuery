WITH unnest_cart_products AS (
    SELECT
        *
        , cart_product
    FROM
        {{ source('L1_Staging', 'checkout_success') }}
        , UNNEST(cart_products) AS cart_product
),  
glamira_transform AS (
    SELECT
        order_id AS order_key
        , CAST(cart_product.product_id AS INT64) AS product_key
        , TIMESTAMP_SECONDS(CAST(time_stamp AS INT64)) AS date_key
        , ip AS location_key
        , COALESCE(NULLIF(cart_product.currency, ''), 'USD $') AS currency_key
        , cart_product.price AS item_price
        , cart_product.amount AS quantity
        , {{ generate_surrogate_key(['order_id', 'cart_product.product_id']) }} AS order_item_id
        , JSON_EXTRACT_SCALAR(option_element, '$.option_label') AS option_label
        , JSON_EXTRACT_SCALAR(option_element, '$.option_id') AS option_id
        , JSON_EXTRACT_SCALAR(option_element, '$.value_label') AS value_label
        , JSON_EXTRACT_SCALAR(option_element, '$.value_id') AS value_id
        , ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY product_id) AS item_sequence 
    FROM
        unnest_cart_products,
        UNNEST(JSON_EXTRACT_ARRAY(cart_product.option)) AS option_element
)

SELECT *
FROM glamira_transform
WHERE REGEXP_CONTAINS(item_price, r'^\d{1,3}(\.\d{3})*(,\d{2})?$') -- Chỉ chọn giá trị hợp lệ
  AND CAST(REPLACE(REPLACE(item_price, '.', ''), ',', '.') AS FLOAT64) > 0
ORDER BY
    order_key,
    product_key,
    item_sequence