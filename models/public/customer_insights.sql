{{
  config(
    materialized='dynamic_table',
    target_lag='DOWNSTREAM',
    snowflake_warehouse='DEMO_WH',
    on_schema_change='fail'
  )
}}

-- Source: CBA Migration Assistant
-- Created: 2025-12-07 14:56:03
-- Target: CBA_DEMO.PUBLIC.customer_insights

SELECT
  c.state,
  b.branch_name,
  DATE_TRUNC('MONTH', a.opened_date) AS month,
  COUNT(DISTINCT a.customer_id) AS total_customers
FROM CBA_DEMO.CUSTOMER_DATA.ACCOUNTS a
LEFT OUTER JOIN CBA_DEMO.CUSTOMER_DATA.CUSTOMERS c
  ON a.customer_id = c.customer_id
LEFT OUTER JOIN CBA_DEMO.CUSTOMER_DATA.BRANCHES b
  ON a.branch_id = b.branch_id
WHERE a.opened_date <= CURRENT_TIMESTAMP()
GROUP BY
  c.state,
  b.branch_name,
  DATE_TRUNC('MONTH', a.opened_date)
ORDER BY
  c.state,
  b.branch_name,
  DATE_TRUNC('MONTH', a.opened_date) DESC NULLS LAST
