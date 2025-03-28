{{ config(
    materialized = 'table',
    schema = 'dw_samssubs'
    )
}}


select
{{ dbt_utils.generate_surrogate_key(['ordermethod']) }} AS OrderMKey,
ordermethod AS OrderMethod
FROM {{ source('subs_source_landing', 'orders') }}