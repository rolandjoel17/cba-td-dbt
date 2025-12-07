{{
  config(
    materialized='dynamic_table',
    target_lag='DOWNSTREAM',
    snowflake_warehouse='DEMO_WH',
    on_schema_change='fail'
  )
}}

-- Source: CBA Migration Assistant
-- Created: 2025-12-07 14:45:00
-- Target: CBA_DEMO.PUBLIC.CUSTOMERS_BRANCH

SELECT
  state,
  branch_name,
  month,
  COUNT(DISTINCT customer_id) AS total_customers,
  MIN(opened_date) AS min_opened_date,
  MAX(opened_date) AS max_opened_date,
  COUNT(opened_date) AS total_account_openings
FROM (
  SELECT DISTINCT
    a.customer_id,
    c.state,
    b.branch_name,
    DATE_TRUNC('MONTH', a.opened_date) AS month,
    a.opened_date
  FROM CBA_DEMO.CUSTOMER_DATA.ACCOUNTS AS a
  LEFT OUTER JOIN CBA_DEMO.CUSTOMER_DATA.CUSTOMERS AS c
    ON a.customer_id = c.customer_id
  LEFT OUTER JOIN CBA_DEMO.CUSTOMER_DATA.BRANCHES AS b
    ON a.branch_id = b.branch_id
  WHERE
    a.opened_date <= CURRENT_TIMESTAMP()
) AS customer_accounts
GROUP BY
  state,
  branch_name,
  month
ORDER BY
  month DESC NULLS LAST,
  state,
  branch_name
