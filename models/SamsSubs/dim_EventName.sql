{{ config(
    materialized = 'table',
    schema = 'dw_samssubs'
    )
}}


select
{{ dbt_utils.generate_surrogate_key(['Event_Name']) }} AS EventKey,
Event_Name AS EventName
FROM {{ source('samsweb_landing', 'web_traffic_events') }}