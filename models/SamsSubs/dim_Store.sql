{{ config(
    materialized = 'table',
    schema = 'dw_samssubs'
    )
}}


select
{{ dbt_utils.generate_surrogate_key(['StoreID']) }} AS StoreKey,
StoreID,
Address AS StoreAddress,
City AS StoreCity,
State AS StoreState,
ZIP AS StoreZIP
FROM {{ source('subs_source_landing', 'store') }}