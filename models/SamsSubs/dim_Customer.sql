{{ config(
    materialized = 'table',
    schema = 'dw_samssubs'
    )
}}


select
{{ dbt_utils.generate_surrogate_key(['CustomerID']) }} AS CustomerKey,
CustomerID,
CUSTOMERFNAME,
CUSTOMERLNAME,
CUSTOMERBDAY AS CustomerBirthDate,
CustomerPhone
FROM {{ source('subs_source_landing', 'customer') }}