{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

SELECT
    c.Cust_Key,
    d.date_key,
    s.store_key,
    p.product_key,
    e.employee_key,
    od.QUANTITY,
    od.unit_price,
    od.unit_price * od.QUANTITY AS Dollars_Sold
FROM {{ source('oliver_landing', 'orderline') }} od
INNER JOIN {{ source('oliver_landing', 'orders')}} o ON o.ORDER_ID = od.ORDER_ID
INNER JOIN {{ ref('oliver_dim_product') }} p ON od.PRODUCT_ID = p.PRODUCT_ID
INNER JOIN {{ ref('oliver_dim_customer')}} c ON c.CUSTOMER_ID = o.CUSTOMER_ID
INNER JOIN {{ ref('oliver_dim_employee')}} e ON e.EMPLOYEE_ID = o.EMPLOYEE_ID
INNER JOIN {{ ref('oliver_dim_store')}} s ON s.store_id = o.store_id
INNER JOIN {{ ref('oliver_dim_date')}} d ON d.DATE_ID = o.ORDER_DATE