SELECT 
    EXTRACT(YEAR FROM fo.date_key) AS sales_year
    ,EXTRACT(WEEK FROM fo.date_key) AS sales_week
    ,ROUND(
        SUM(
        SAFE_CAST(
            REPLACE(REPLACE(fo.item_price, '.', ''), ',', '.') AS FLOAT64  
        ) 
        * dc.exchange_rate_to_usd  
        * fo.quantity),
        4
        ) AS sales_in_US_dollar
FROM 
    {{ ref("fact_orders")}} fo
INNER JOIN 
    {{ ref("dim_date")}} dd
ON
    fo.date_key = dd.date_key
INNER JOIN 
    {{ ref('dim_currency') }} dc
    ON fo.currency_key = dc.currency_key
GROUP BY 
    sales_year
    ,sales_week
ORDER BY 
    sales_year
    ,sales_week