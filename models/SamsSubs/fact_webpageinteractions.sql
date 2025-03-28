{{ config(
    materialized = 'table',
    schema = 'dw_samssubs'
) }}

SELECT
    e.EventKey,
    s.SourceKey,
    w.WebpageKey,
    sc.event_timestamp AS DateKey,
    sc.User_Email AS UserEmail,
    sc._Line AS InteractionCount
FROM {{ source('samsweb_landing', 'web_traffic_events') }} sc
INNER JOIN {{ ref('dim_EventName') }} e ON e.EventName = sc.Event_Name
INNER JOIN {{ ref('dim_TrafficSource')}} s ON s.SourceName = sc.Traffic_Source
INNER JOIN {{ ref('dim_Webpage')}} w ON w.webpageurl = sc.page_url