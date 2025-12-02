{{
  config(
    materialized='dynamic_table',
    target_lag='DOWNSTREAM',
    snowflake_warehouse='DEMO_WH',
    on_schema_change='fail'
  )
}}

-- Source: CBA Migration Assistant
-- Created: 2025-12-02 15:53:10
-- Target: CBA_DEMO.PUBLIC.test50

SELECT customer_id, COUNT(*) as total_count FROM CBA_DEMO.PUBLIC.CUSTOMER_DATA GROUP BY customer_id
