{{
  config(
    materialized='dynamic_table',
    target_lag='DOWNSTREAM',
    snowflake_warehouse='DEMO_WH',
    on_schema_change='fail'
  )
}}

-- Source: CBA Migration Assistant
-- Created: 2025-12-07 15:00:16
-- Target: CBA_DEMO.PUBLIC.customer_details

WITH __accounts AS (
  SELECT
    opened_date,
    branch_id,
    customer_id
  FROM CBA_DEMO.CUSTOMER_DATA.ACCOUNTS
), __customers AS (
  SELECT
    state,
    customer_id
  FROM CBA_DEMO.CUSTOMER_DATA.CUSTOMERS
), __branches AS (
  SELECT
    branch_name,
    branch_id
  FROM CBA_DEMO.CUSTOMER_DATA.BRANCHES
), customer_accounts AS (
  SELECT DISTINCT
    a.customer_id,
    c.state,
    b.branch_name,
    a.opened_date
  FROM __accounts AS a
  LEFT OUTER JOIN __customers AS c
    ON a.customer_id = c.customer_id
  LEFT OUTER JOIN __branches AS b
    ON a.branch_id = b.branch_id
  WHERE
    a.opened_date <= CURRENT_DATE
)
SELECT
  state,
  branch_name,
  DATE_TRUNC('MONTH', opened_date) AS month,
  COUNT(customer_id) AS total_customers,
  MIN(opened_date) AS min_opened_date,
  MAX(opened_date) AS max_opened_date,
  COUNT(opened_date) AS count_opened_dates
FROM customer_accounts
GROUP BY
  state,
  branch_name,
  DATE_TRUNC('MONTH', opened_date)
ORDER BY
  month DESC NULLS LAST,
  state,
  branch_name
