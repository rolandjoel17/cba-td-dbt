{{
  config(
    materialized='dynamic_table',
    target_lag='DOWNSTREAM',
    snowflake_warehouse='DEMO_WH',
    on_schema_change='fail'
  )
}}

-- Source: CBA Migration Assistant
-- Created: 2025-12-07 19:03:04
-- Target: CBA_DEMO.PUBLIC.branch_summary_month

SELECT
  DATE_TRUNC('MONTH', t.transaction_date) AS month,
  c.state,
  b.branch_name,
  COUNT(DISTINCT a.customer_id) AS total_customers,
  COUNT(t.transaction_date) AS total_transactions,
  MIN(t.transaction_date) AS min_transaction_date,
  MAX(t.transaction_date) AS max_transaction_date,
  AVG(COUNT(t.transaction_date)) OVER (PARTITION BY c.state, b.branch_name ORDER BY DATE_TRUNC('MONTH', t.transaction_date) ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS avg_transactions_3month,
  COUNT(DISTINCT a.customer_id) / COUNT(t.transaction_date) AS customers_per_transaction_ratio
FROM CBA_DEMO.CUSTOMER_DATA.TRANSACTIONS t
LEFT JOIN CBA_DEMO.CUSTOMER_DATA.ACCOUNTS a ON t.account_id = a.account_id
LEFT JOIN CBA_DEMO.CUSTOMER_DATA.CUSTOMERS c ON a.customer_id = c.customer_id
LEFT JOIN CBA_DEMO.CUSTOMER_DATA.BRANCHES b ON a.branch_id = b.branch_id
WHERE t.transaction_date <= CURRENT_TIMESTAMP()
GROUP BY
  DATE_TRUNC('MONTH', t.transaction_date),
  c.state,
  b.branch_name
ORDER BY
  month DESC NULLS LAST,
  state,
  branch_name
