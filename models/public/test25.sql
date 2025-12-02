{{
  config(
    materialized='dynamic_table',
    target_lag='1 hour',
    snowflake_warehouse='DEMO_WH',
    on_schema_change='fail'
  )
}}

-- Source: CBA Migration Assistant
-- Created: 2025-12-01 19:31:00
-- Target: CBA_DEMO.PUBLIC.test25

SELECT customer_id, COUNT(*) as total_count FROM CBA_DEMO.PUBLIC.CUSTOMER_DATA GROUP BY customer_id
