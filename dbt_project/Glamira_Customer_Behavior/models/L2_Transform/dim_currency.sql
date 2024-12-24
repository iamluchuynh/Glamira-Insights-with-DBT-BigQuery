SELECT 
    '€' AS currency_key, 1.1 AS exchange_rate_to_usd -- 1 US$ = 1.1 €, Tiền tệ của khu vực đồng Euro
UNION ALL
SELECT 'kr', 0.1       -- 1 US$ = 0.1 kr, Tiền tệ của Thụy Điển (SEK)
UNION ALL
SELECT '₺', 0.036      -- 1 US$ = 0.036 ₺, Tiền tệ của Thổ Nhĩ Kỳ (TRY)
UNION ALL
SELECT 'R$', 0.2       -- 1 US$ = 0.2 R$, Tiền tệ của Brazil (BRL)
UNION ALL
SELECT 'CAD $', 0.75   -- 1 US$ = 0.75 CAD $, Tiền tệ của Canada
UNION ALL
SELECT 'zł', 0.25      -- 1 US$ = 0.25 zł, Tiền tệ của Ba Lan (PLN)
UNION ALL
SELECT 'din.', 0.008   -- 1 US$ = 0.008 din., Tiền tệ của Serbia (RSD)
UNION ALL
SELECT '₫', 0.000042   -- 1 US$ = 0.000042 ₫, Tiền tệ của Việt Nam (VND)
UNION ALL
SELECT 'kn', 0.14      -- 1 US$ = 0.14 kn, Tiền tệ của Croatia (HRK)
UNION ALL
SELECT '$', 1.0        -- 1 US$ = 1 $, Tiền tệ của Hoa Kỳ (hoặc các nước dùng USD)
UNION ALL
SELECT 'лв.', 0.56     -- 1 US$ = 0.56 лв., Tiền tệ của Bulgaria (BGN)
UNION ALL
SELECT 'BOB Bs', 0.14  -- 1 US$ = 0.14 BOB Bs, Tiền tệ của Bolivia (BOB)
UNION ALL
SELECT 'COP $', 0.00026 -- 1 US$ = 0.00026 COP $,Tiền tệ của Colombia (COP)
UNION ALL
SELECT 'CRC ₡', 0.0016  -- 1 US$ = 0.0016, Tiền tệ của Costa Rica (CRC)
UNION ALL
SELECT 'USD $', 1.0     -- 1 US$ = 1 USD $, Tiền tệ của Hoa Kỳ (USD)
UNION ALL
SELECT 'CLP', 0.0011    -- 1 US$ = 0.0011 CLP, Tiền tệ của Chile (CLP)
UNION ALL
SELECT 'Lei', 0.22      -- 1 US$ = 0.22 Lei, Tiền tệ của Romania (RON)
UNION ALL
SELECT 'UYU', 0.026     -- 1 US$ = 0.026 UYU, Tiền tệ của Uruguay (UYU)
UNION ALL
SELECT '₵', 0.17        -- 1 US$ = 0.17 ₵, Tiền tệ của Ghana (GHS)