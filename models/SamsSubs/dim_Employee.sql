{{ config(
    materialized = 'table',
    schema = 'dw_samssubs'
    )
}}


select
{{ dbt_utils.generate_surrogate_key(['Employeeid']) }} AS EmployeeKey,
EmployeeID,
EmployeeFName,
EmployeeLName,
EmployeeBDay AS EmployeeBirthDate
FROM {{ source('subs_source_landing', 'employee') }}