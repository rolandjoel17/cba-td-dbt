{{
  config(
    materialized='dynamic_table',
    target_lag='DOWNSTREAM',
    snowflake_warehouse='DEMO_WH',
    on_schema_change='fail'
  )
}}

-- Source: CBA Migration Assistant
-- Created: 2025-12-07 14:51:17
-- Target: CBA_DEMO.PUBLIC.branch_data

SELECT
  state,
  branch_name,
  month,
  COUNT(customer_id) AS total_customers
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
) customer_accounts
GROUP BY
  state,
  branch_name,
  month
ORDER BY
  month DESC NULLS LAST,
  state,
  branch_name
