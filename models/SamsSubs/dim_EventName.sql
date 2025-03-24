{{ config(
    materialized = 'table',
    schema = 'dw_samssubs'
    )
}}


select
EVENT_NAME AS EventKey,
EVENT_NAME AS EventName
FROM {{ source('samsweb_landing', 'web_traffic_events') }}