{{
  config(
    materialized='dynamic_table',
    target_lag='1 hour',
    snowflake_warehouse='DEMO_WH',
    on_schema_change='fail'
  )
}}

-- Source: CBA Migration Assistant
-- Created: 2025-12-02 14:20:40
-- Target: CBA_DEMO.PUBLIC.test47

SELECT customer_id, COUNT(*) as total_count FROM CBA_DEMO.PUBLIC.CUSTOMER_DATA GROUP BY customer_id
