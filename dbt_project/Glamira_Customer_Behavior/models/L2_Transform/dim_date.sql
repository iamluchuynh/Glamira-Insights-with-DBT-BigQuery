{{ config(
   partition_by={
       "field": "date",
       "data_type": "date", 
       "granularity": "day"
   },
   cluster_by=['year', 'month', 'day']
)}}

WITH timestamp_transform AS (
SELECT DISTINCT
   TIMESTAMP_SECONDS(CAST(time_stamp AS INT64)) AS date_key
   ,DATE(TIMESTAMP_SECONDS(CAST(time_stamp AS INT64))) as date
   ,EXTRACT(YEAR FROM TIMESTAMP_SECONDS(CAST(time_stamp AS INT64))) as year
   ,EXTRACT(MONTH FROM TIMESTAMP_SECONDS(CAST(time_stamp AS INT64))) as month
   ,EXTRACT(DAY FROM TIMESTAMP_SECONDS(CAST(time_stamp AS INT64))) as day
FROM `Glamira_Customer_Behavior.Data_Raw`
)
SELECT *
FROM timestamp_transform