{{ config(
    materialized = 'table',
    schema = 'dw_samssubs'
    )
}}


select
{{ dbt_utils.generate_surrogate_key(['Page_Url']) }} AS WebpageKey,
Page_Url AS WebpageURL
FROM {{ source('samsweb_landing', 'web_traffic_events') }}