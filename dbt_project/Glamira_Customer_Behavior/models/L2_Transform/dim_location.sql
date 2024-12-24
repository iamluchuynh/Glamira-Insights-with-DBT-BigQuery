SELECT
    IP as location_key
    , IF(SPLIT(`IP-COUNTRY-REGION-CITY`, ", ")[SAFE_OFFSET(0)] = '-', 'Unknown', SPLIT(`IP-COUNTRY-REGION-CITY`, ", ")[SAFE_OFFSET(0)]) AS country_short
    , IF(SPLIT(`IP-COUNTRY-REGION-CITY`, ", ")[SAFE_OFFSET(1)] = '-', 'Unknown', SPLIT(`IP-COUNTRY-REGION-CITY`, ", ")[SAFE_OFFSET(1)]) AS country_key
    , IF(SPLIT(`IP-COUNTRY-REGION-CITY`, ", ")[SAFE_OFFSET(2)] = '-', 'Unknown', SPLIT(`IP-COUNTRY-REGION-CITY`, ", ")[SAFE_OFFSET(2)]) AS region
    , IF(SPLIT(`IP-COUNTRY-REGION-CITY`, ", ")[SAFE_OFFSET(3)] = '-', 'Unknown', SPLIT(`IP-COUNTRY-REGION-CITY`, ", ")[SAFE_OFFSET(3)]) AS city_key
FROM
    `Glamira_Customer_Behavior.IP2Location`









