{{ config(
    materialized = 'table',
    schema = 'dw_samssubs'
    )
}}


select
{{ dbt_utils.generate_surrogate_key(['Traffic_Source']) }} AS SourceKey,
Traffic_Source AS SourceName
FROM {{ source('samsweb_landing', 'web_traffic_events') }}