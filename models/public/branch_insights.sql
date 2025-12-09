{{
  config(
    materialized='dynamic_table',
    target_lag='DOWNSTREAM',
    snowflake_warehouse='DEMO_WH',
    on_schema_change='fail'
  )
}}

-- Source: CBA Migration Assistant
-- Created: 2025-12-08 20:49:58
-- Target: CBA_DEMO.PUBLIC.branch_insights

SELECT
  ca.state,
  ca.branch_name,
  ca.month,
  COUNT(ca.customer_id) AS total_customers,
  MIN(ca.month) AS min_month,
  MAX(ca.month) AS max_month,
  COUNT(ca.month) AS month_count
FROM (
  SELECT DISTINCT
    a.customer_id,
    c.state,
    b.branch_name,
    DATE_TRUNC('MONTH', a.opened_date) AS month
  FROM CBA_DEMO.CUSTOMER_DATA.ACCOUNTS a
  LEFT OUTER JOIN CBA_DEMO.CUSTOMER_DATA.CUSTOMERS c
    ON a.customer_id = c.customer_id
  LEFT OUTER JOIN CBA_DEMO.CUSTOMER_DATA.BRANCHES b
    ON a.branch_id = b.branch_id
  WHERE
    a.opened_date <= CURRENT_TIMESTAMP()
) ca
GROUP BY
  ca.state,
  ca.branch_name,
  ca.month
ORDER BY
  ca.month DESC NULLS LAST,
  ca.state,
  ca.branch_name
