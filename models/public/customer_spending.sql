{{
  config(
    materialized='dynamic_table',
    target_lag='DOWNSTREAM',
    snowflake_warehouse='DEMO_WH',
    on_schema_change='fail'
  )
}}

-- Source: CBA Migration Assistant
-- Created: 2025-12-07 15:57:23
-- Target: CBA_DEMO.PUBLIC.customer_spending

SELECT sv.customer_name, sv.total_transaction_amount, RANK() OVER (ORDER BY sv.total_transaction_amount DESC NULLS LAST) AS spending_rank FROM SEMANTIC_VIEW( CBA_DEMO.CUSTOMER_DATA.CUSTOMER_BANKING_VIEW METRICS transactions.total_transaction_amount DIMENSIONS customers.customer_name ) AS sv ORDER BY sv.total_transaction_amount DESC NULLS LAST
