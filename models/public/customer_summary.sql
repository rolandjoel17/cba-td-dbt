{{
  config(
    materialized='dynamic_table',
    target_lag='1 hour',
    snowflake_warehouse='DEMO_WH',
    on_schema_change='fail'
  )
}}

-- Source: CBA Migration Assistant
-- Created: 2025-11-26 22:13:18
-- Target: CBA_DEMO.PUBLIC.CUSTOMER_SUMMARY

SELECT customer_id, COUNT(*) as total_count FROM customers GROUP BY customer_id
