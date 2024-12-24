SELECT 
    dil.country_key as country
    ,ROUND(
      SUM(
        SAFE_CAST(
          REPLACE(REPLACE(fo.item_price, '.', ''), ',', '.') AS FLOAT64  
        ) 
        * dc.exchange_rate_to_usd  
        * fo.quantity),
        4
      ) AS revenue_in_US_dollar
FROM {{ ref("fact_orders") }} fo
INNER JOIN {{ ref("dim_location") }} dil
    ON fo.location_key = dil.location_key
INNER JOIN {{ ref('dim_currency') }} dc
    ON fo.currency_key = dc.currency_key
GROUP BY country