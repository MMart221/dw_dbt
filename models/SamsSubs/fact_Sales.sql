{{ config(
    materialized = 'table',
    schema = 'dw_samssubs'
) }}

SELECT
    o.OrderNumber,
    DATE(od.OrderDate) AS DateKey,
    e.EmployeeKey,
    s.StoreKey,
    p.ProductKey,
    c.CustomerKey,
    o.OrderLineQTY AS Quantity,
    o.OrderLinePrice AS OrderLineTotal,
    (o.OrderLinePrice / o.OrderLineQTY) AS ProductCost,
    om.OrderMKey,
    o.PointsEarned
FROM {{ source('subs_source_landing', 'orderdetails') }} o
INNER JOIN {{ source('subs_source_landing', 'orders') }} od ON od.ordernumber = o.ordernumber
INNER JOIN {{ source('subs_source_landing', 'employee') }} em ON em.employeeid = od.employeeid
INNER JOIN {{ ref('dim_Product') }} p ON p.productid = o.productid
INNER JOIN {{ ref('dim_OrderMethod')}} om ON om.ordermethod = od.ordermethod
INNER JOIN {{ ref('dim_Employee')}} e ON e.EmployeeID = od.Employeeid
INNER JOIN {{ ref('dim_Customer')}} c ON c.CustomerID = od.customerid
INNER JOIN {{ ref('dim_Store')}} s ON s.StoreID = em.storeid

