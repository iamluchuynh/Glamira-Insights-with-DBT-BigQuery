WITH filtered_data AS (
    SELECT 
        *
    FROM 
        `Glamira_Customer_Behavior.Data_Raw`
    WHERE 
        collection = 'checkout_success'
)

SELECT 
    time_stamp
    , ip
    , store_id
    , local_time
    , current_url
    , order_id
    , cart_products
FROM 
    filtered_data