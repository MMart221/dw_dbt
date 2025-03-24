select
    fs.date_key,
    fs.store_key,
    fs.product_key,
    fs.employee_key,
    fs.cust_key,
    fs.quantity,
    fs.unit_price,
    fs.dollars_sold,

    c.first_name AS CustFName,
    c.last_name AS CustLName,
    p.product_name,
    s.store_name,
    s.street,
    s.city,
    s.state,
    e.first_name AS EmpFName,
    e.last_name AS EmpLName,
    e.hire_date,
    e.position,
    d.DayOfWeek,
    d.month,
    d.quarter,
    d.Year


from {{ ref('fact_sales') }} fs
left join {{ ref('oliver_dim_customer') }} c on fs.cust_key = c.cust_key
left join {{ ref('oliver_dim_product') }} p on fs.product_key = p.product_key
left join {{ ref('oliver_dim_store') }} s on fs.store_key = s.store_key
left join {{ ref('oliver_dim_employee') }} e on fs.employee_key = e.employee_key
left join {{ ref('oliver_dim_date') }} d on fs.date_key = d.date_key