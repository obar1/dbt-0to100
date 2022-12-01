CREATE TABLE raw.public.apps AS
SELECT  cast(NULL AS varchar) AS id,
        cast(NULL AS integer) AS num
UNION ALL
SELECT  'prod_a',
        123
UNION ALL
SELECT  'prod_b',
        456
UNION ALL
SELECT  'prod_c',
        789
