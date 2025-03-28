{{ config(
    materialized = 'table',
    schema = 'dw_samssubs'
    )
}}


select
{{ dbt_utils.generate_surrogate_key(['p.ProductID']) }} AS ProductKey,
p.ProductID AS ProductID,
ProductType,
ProductName,
ProductCalories,
Length AS SandwichLength,
BreadType
FROM {{ source('subs_source_landing', 'product') }} p
LEFT JOIN {{ source('subs_source_landing', 'sandwich') }} s ON p.ProductID = s.ProductID