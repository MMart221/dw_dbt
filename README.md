# Sam's Subs — Data Warehouse & dbt Pipeline

An end-to-end data warehousing project built on **Snowflake**, **dbt Cloud**, and **Fivetran**. Starting from a raw OLTP transactional database, this project walks through the full lifecycle: data normalization, star schema design, ELT pipeline implementation, and business intelligence querying.

---

## Tech Stack

| Tool | Role |
|------|------|
| **SQL Server (SSMS)** | OLTP database design and normalization |
| **Snowflake** | Cloud data warehouse (OLAP) |
| **Fivetran** | Automated data ingestion from OLTP → Snowflake |
| **dbt Cloud** | ELT transformations, data modeling, and testing |
| **Tableau** | End-user visualization and dashboarding |

---

## Project Overview

### Phase 1 — OLTP Database Design
Normalized raw sandwich consumption data into a 3rd Normal Form (3NF) relational schema in SQL Server, covering 7 tables: `Orders`, `Customer`, `Employee`, `Store`, `Product`, `OrderLine`, and `Sandwich`.

### Phase 2 — Star Schema Design
Redesigned the OLTP schema into a dimensional model (star schema) optimized for analytical queries. Key design decisions:
- Separated `OrderMethod` into its own dimension to reduce fact table redundancy
- Introduced `DateDim` with `DayOfWeek`, `Quarter`, and `Month` fields for richer time-based analysis
- Identified `DateDim` as a **conformed dimension**, shared across both `SalesFact` and `WebpageInteractionsFact`
- Removed denormalized sandwich fields from `ProductDim` for cleaner modeling

### Phase 3 — ELT Pipeline (Fivetran + dbt)
Used Fivetran to load data from the SQL Server OLTP database into Snowflake. Built dbt models to transform and load the dimensional warehouse, including:
- Staging models to clean and standardize source data
- Dimension and fact table builds with referential integrity
- dbt tests to validate key relationships and null constraints

### Phase 4 — Business Intelligence & Recommendations
Queried the populated warehouse to answer real business questions and delivered a customer-facing Tableau dashboard ("Your Year in Review") alongside a data improvement proposal for Sam's Subs leadership.

---

## Sample Business Queries

**Top-selling sandwich by day of the week**
```sql
SELECT DayOfWeek, ProductName AS TopSellingSandwich, TotalQuantitySold
FROM (
  SELECT
    DATENAME(dw, o.OrderDate) AS DayOfWeek,
    p.ProductName,
    SUM(ol.Quantity) AS TotalQuantitySold,
    RANK() OVER (PARTITION BY DATENAME(dw, o.OrderDate) ORDER BY SUM(ol.Quantity) DESC) AS rnk
  FROM Orders o
  JOIN OrderLine ol ON o.OrderID = ol.OrderID
  JOIN Product p ON ol.ProductID = p.ProductID
  WHERE p.ProductType = 'sandwich'
  GROUP BY DATENAME(dw, o.OrderDate), p.ProductName
) ranked
WHERE rnk = 1
ORDER BY CASE
  WHEN DayOfWeek = 'Monday' THEN 1
  WHEN DayOfWeek = 'Tuesday' THEN 2
  WHEN DayOfWeek = 'Wednesday' THEN 3
  WHEN DayOfWeek = 'Thursday' THEN 4
  WHEN DayOfWeek = 'Friday' THEN 5
  WHEN DayOfWeek = 'Saturday' THEN 6
  WHEN DayOfWeek = 'Sunday' THEN 7
END;
```

**High-calorie vs. low-calorie sandwich sales**
```sql
SELECT
  CASE WHEN ProductCalories >= 600 THEN 'High Cal' ELSE 'Low Cal' END AS CalorieCategory,
  COUNT(o.ProductID) AS TotalAmountSold
FROM Product p
JOIN OrderLine o ON p.ProductID = o.ProductID
WHERE ProductType = 'Sandwich'
GROUP BY CASE WHEN ProductCalories >= 600 THEN 'High Cal' ELSE 'Low Cal' END
ORDER BY TotalAmountSold DESC;
```

**Employee of the Year — top revenue generator**
```sql
SELECT e.EmployeeID, EmployeeFName, EmployeeLName, SUM(OrderTotal) AS TotalSales
FROM Employee e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
WHERE OrderDate > '2022'
GROUP BY e.EmployeeID, EmployeeFName, EmployeeLName
ORDER BY TotalSales DESC;
```

---

## Data Improvement Proposal

Proposed a customer email capture strategy to link `SalesFact` and `WebpageInteractionsFact` under a single `CustomerKey` — turning `CustomerDim` into a true conformed dimension across both fact tables. This enables cross-channel attribution, richer segmentation, and enhanced loyalty program analytics.

---

## Project Report & Documentation

- 📄 [Full Project Report (PDF)](https://drive.google.com/file/d/1qJtGWKicjCh1x0D247R5YpvZNE2ec2Dt/view)

---

## Running the dbt Project

```bash
dbt run       # Build all models
dbt test      # Run data quality tests
dbt docs generate && dbt docs serve  # View lineage graph
```
