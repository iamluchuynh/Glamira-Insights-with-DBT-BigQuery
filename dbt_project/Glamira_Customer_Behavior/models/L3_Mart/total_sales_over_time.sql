WITH sales_total AS (
  SELECT 
    dd.year
    ,dd.month
    ,ROUND(
      SUM(
        SAFE_CAST(
          REPLACE(REPLACE(fo.item_price, '.', ''), ',', '.') AS FLOAT64  
        ) 
        * dc.exchange_rate_to_usd  
        * fo.quantity),
        4
      ) AS sales_total_in_US_dollar
  FROM 
    {{ ref('fact_orders') }} fo
  INNER JOIN 
    {{ ref('dim_date') }} dd
    ON fo.date_key = dd.date_key
  INNER JOIN 
    {{ ref('dim_currency') }} dc
    ON fo.currency_key = dc.currency_key
  WHERE 
    fo.item_price IS NOT NULL
  GROUP BY 
    dd.year
    ,dd.month
)

SELECT *
FROM sales_total
ORDER BY year, month
