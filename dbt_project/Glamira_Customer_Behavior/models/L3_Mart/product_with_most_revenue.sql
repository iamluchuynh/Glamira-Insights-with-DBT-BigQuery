SELECT
    dp.product_key,
    dp.product_name,
    ROUND(
      SUM(
        COALESCE(
          SAFE_CAST(
            REPLACE(REPLACE(fo.item_price, '.', ''), ',', '.') AS FLOAT64  
          ) 
          * dc.exchange_rate_to_usd  
          * fo.quantity,
          0
        )
      ),
      4
    ) AS product_revenue_in_US_dollar
FROM {{ ref('dim_product') }}  dp
LEFT JOIN {{ ref('fact_orders') }} fo
    ON fo.product_key = dp.product_key
LEFT JOIN {{ ref('dim_currency') }} dc
    ON fo.currency_key = dc.currency_key
GROUP BY dp.product_key, dp.product_name
ORDER BY product_revenue_in_US_dollar DESC
