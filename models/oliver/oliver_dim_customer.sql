{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
    )
}}


select
customer_id as Cust_Key,
customer_id,
first_name,
last_name,
Email,
Phone_Number,
state,
FROM {{ source('oliver_landing', 'customer') }}