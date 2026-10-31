-- Gold: paid revenue per sales channel (refunded orders excluded).
-- TODO (step 4.1): write the query. Expected result: 3 rows, total 21,436 GBP.
--   columns: channel, paid_orders (count of distinct order_id), revenue_gbp (sum of line_revenue_gbp)


SELECT
    channel,
    COUNT(distinct order_id) as paid_orders,
    SUM(line_revenue_gbp) as revenue_gbp
from {{ ref('silver_order_lines') }}
WHERE status = 'paid'
GROUP BY channel
