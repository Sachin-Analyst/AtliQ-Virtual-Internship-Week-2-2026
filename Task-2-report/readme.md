# Week 2 - Task 2: SQL Query Debugging

**AtliQ Technologies | Virtual Data Analyst Internship**
**Intern:** Vishnu Ram Sachin | **Date:** 25.07.2026

## Overview

This task was not about writing new SQL, it was about reading it critically. I was handed 9 broken queries against the `gdb080` database and had to find why each one failed, then rewrite it so it runs correctly.

None of the bugs involved logic. Every single one was a small syntax detail: a missing keyword, a misplaced bracket, a mismatched quote, a clause in the wrong order. The kind of thing your eyes skip past because your brain already knows what the query is supposed to say.

## Database

`gdb080` - tables used across the 9 queries: `dim_customers`, `dim_products`, `dim_targets_orders`, `fact_order_lines`, `fact_orders_aggregate`

## Approach

For each query:
1. Run it and read the actual error message, not just skim the query
2. Isolate the exact line/clause causing the failure
3. Fix only what's broken, keep the original logic intact
4. Note the root cause in plain English

---

## Query 1 of 9 - Unique customers in the city of 'Surat'

**The Bug**
```sql
SELECT
    COUNT(DISTINCT customer_id) AS distinct_customers
FORM gdb080.dim_customers
WHERE city == 'surat';
```

**The Fix**
```sql
SELECT
    DISTINCT(COUNT(customer_id)) AS unique_customers
FROM gdb080.dim_customers
WHERE city = "Surat";
```

**Root cause:** `FORM` was a typo for `FROM`. MySQL doesn't support `==`, only `=` or `LIKE`.

---

## Query 2 of 9 - Min and max order quantities per product

**The Bug**
```sql
SELECT
    p.product_id,
    p.product_name,
    MIN(p.order_qty) as minimum_qty
    MAX(p.order_qty) as maximum_qty
FROM gdb080.fact_order_lines f
JOIN gdb080.dim_products p ON f.product_id = p.product_id
GROUP BY p.product_id;
```

**The Fix**
```sql
SELECT
    dp.product_id,
    dp.product_name,
    MIN(fol.order_qty) AS min_order_qty,
    MAX(fol.order_qty) AS max_order_qty
FROM fact_order_lines fol
JOIN dim_products dp
    ON dp.product_id = fol.product_id
GROUP BY dp.product_id;
```

**Root cause:** Missing comma in the SELECT list. Also, `order_qty` lives in the fact table, not the product table.

---

## Query 3 of 9 - Unfulfilled orders (order_qty - delivery_qty) by month

**The Bug**
```sql
SELECT
    MONTHNAME(order_placement_date as month_name,
    SUM(order_qty-delivery_qty)
FROM gdb080.fact_orders_lines
GROUP BY MONTHNAME(order_placement_date)
ORDER BY unfullfilled_orders DESC;
```

**The Fix**
```sql
SELECT
    MONTHNAME(order_placement_date) as month_name,
    SUM(order_qty-delivery_qty) AS unfullfilled_orders
FROM gdb080.fact_order_lines
GROUP BY MONTHNAME(order_placement_date)
ORDER BY unfullfilled_orders DESC;
```

**Root cause:** Closing bracket was in the wrong place on `MONTHNAME(...)`. Gave the `SUM` an alias so `ORDER BY` could find it.

---

## Query 4 of 9 - Percentage breakdown of order_qty by category

**The Bug**
```sql
WITH total_order_qty_by_category AS
(
    SELECT
        p.category,
        SUM(f.order_qty) as total_quantity
    FROM gdb080.dim_products p
    JOIN gdb080.fact_order_lines f ON p.product_id = f.product_id
    GROUP BY p.category ;
)
SELECT
    category,
    ROUND(100 * total_quantity / SUM(total_quantity) OVER (), 2) AS order_qty_pct
FROM total_order_quantity_by_category
order by order_qty_pct DESC;
```

**The Fix**
```sql
WITH total_order_qty_by_category AS
(
    SELECT
        p.category,
        SUM(f.order_qty) AS total_quantity
    FROM dim_products p
    JOIN fact_order_lines f ON p.product_id = f.product_id
    GROUP BY p.category
)
SELECT
    category,
    ROUND(100 * total_quantity / SUM(total_quantity) OVER (), 2) AS order_qty_pct
FROM total_order_qty_by_category
ORDER BY order_qty_pct DESC ;
```

**Root cause:** A semicolon inside the CTE ended the query early. The CTE name also didn't match between the `WITH` clause and the final `FROM`.

---

## Query 5 of 9 - Customer on-time target % and percentage category

**The Bug**
```sql
SELECT
    customer_id,
    customer_name,
    t.ontime_target_pct,
    CASE
        WHEN t.ontime_target_pct > 90 THEN 'Above 90"
        WHEN t.ontime_target_pct > 80 THEN 'Above 80'
        WHEN t.ontime_target_pct > 70 THEN 'Above 70'
        ELSE "Below 70"
    END ASpercentage_category ,
FROM gdb080.dim_targets_orders t
JOIN gdb080.dim_customers c
    ON t.customer_id = c.customer_id;
```

**The Fix**
```sql
SELECT
    c.customer_id,
    c.customer_name,
    t.ontime_target_pct,
    CASE
        WHEN t.ontime_target_pct > 90 THEN 'Above 90'
        WHEN t.ontime_target_pct > 80 THEN 'Above 80'
        WHEN t.ontime_target_pct > 70 THEN 'Above 70'
        ELSE 'Below 70'
    END AS percentage_category
FROM gdb080.dim_targets_orders t
JOIN gdb080.dim_customers c
    ON t.customer_id = c.customer_id;
```

**Root cause:** Quotation marks didn't match on one of the `CASE` branches. `customer_id` and `customer_name` needed a table prefix since both tables were joined. Trailing comma before `FROM` was removed.

---

## Query 6 of 9 - Product categories with product name and count per category

**The Bug**
```sql
SELECT category, GROUP_CONCAT(product_name)
AS products COUNT(*) AS product_count
FROM gdb080.dim_products
GROUP category;
```

**The Fix**
```sql
SELECT category, GROUP_CONCAT(product_name) AS products,
    COUNT(*) AS product_count
FROM gdb080.dim_products
GROUP BY category;
```

**Root cause:** Missing comma between the two output columns. `GROUP BY` needs the `BY` keyword, `GROUP` alone doesn't work.

---

## Query 7 of 9 - Top 3 most demanded products in the 'Dairy' category (order_qty in Mlns)

**The Bug**
```sql
SELECT
    p.product_name,
    ROUND(SUM(f.order_qt) / 1000000,2) AS order_qty_mln
FROM gdb080.dim_products p
JOIN gdb080.fact_order_lines f
WHERE p.category ='Dairy'
GROUP BY p.product_name
ORDER BY order_qty_mln DESC
LIMIT 3;
```

**The Fix**
```sql
SELECT
    p.product_name,
    ROUND(SUM(f.order_qty) / 1000000,2) AS order_qty_mln
FROM gdb080.dim_products p
JOIN gdb080.fact_order_lines f
    ON p.product_id = f.product_id
WHERE p.category ='Dairy'
GROUP BY p.product_name
ORDER BY order_qty_mln DESC
LIMIT 3;
```

**Root cause:** `order_qt` was missing a letter. The `JOIN` had no `ON` clause, so the engine had no way to connect the two tables.

---

## Query 8 of 9 - OTIF % for customer "Vijay Stores"

**The Bug**
```sql
SELECT
    c.customer_names,
    ROUND((SUM(f.otif) / COUNT(f.order_id) * 100),2) AS OTIF_percentage
FROM gdb080.fact_orders_aggregate f
JOIN gdb080.dim_customers c
    ON c.customer_id = f.customer_id
GROUP BY c.customer_name
WHERE c.customer_name ="Vijay Stores";
```

**The Fix**
```sql
SELECT
    c.customer_name,
    ROUND((SUM(f.otif) / COUNT(f.order_id) * 100),2) AS OTIF_percentage
FROM gdb080.fact_orders_aggregate f
JOIN gdb080.dim_customers c
    ON c.customer_id = f.customer_id
WHERE c.customer_name ="Vijay Stores"
GROUP BY c.customer_name;
```

**Root cause:** `customer_name` column had an extra letter (`customer_names`). `WHERE` was placed after `GROUP BY`, it needs to come before.

---

## Query 9 of 9 - In-Full % per product and which product ranks highest

**The Bug**
```sql
WITH product_if_target AS (
    SELECT
        p.product_name,
        SUM(CASE WHEN f.in_full = 1 THEN 1 ELSE 0) AS if_count,
        COUNT(f.order_id) AS total_count
    FROM gdb080.fact_order_lines f
    JOIN gdb080.dim_products p ON p.product_id = f.product_id
    GROUP BY p.product_name
)
SELECT
    product_name,
    ROUND(if_count / total_count * 100), 2) AS IF_percentage
FROM product_if_target
order by IF_percentage DESC;
```

**The Fix**
```sql
WITH product_if_target AS (
    SELECT
        p.product_name,
        SUM(CASE WHEN f.in_full = 1 THEN 1 ELSE 0 END) AS if_count,
        COUNT(f.order_id) AS total_count
    FROM gdb080.fact_order_lines f
    JOIN gdb080.dim_products p ON p.product_id = f.product_id
    GROUP BY p.product_name
)
SELECT
    product_name,
    ROUND(if_count / total_count * 100, 2) AS IF_percentage
FROM product_if_target
ORDER BY IF_percentage DESC;
```

**Root cause:** `CASE` statement was missing its `END`. An extra closing bracket broke the `ROUND()` function.

---

## Bug Patterns Observed

| # | Pattern | Queries affected |
|---|---------|-------------------|
| 1 | Keyword typo (`FORM`, `GROUP` without `BY`) | 1, 6 |
| 2 | Wrong comparison/quote syntax (`==`, mismatched quotes) | 1, 5 |
| 3 | Missing comma in SELECT list | 2, 6 |
| 4 | Misplaced or missing bracket | 3, 9 |
| 5 | Semicolon or clause ending a CTE/query early | 4 |
| 6 | CTE name mismatch between `WITH` and `FROM` | 4 |
| 7 | Missing table alias/prefix on ambiguous column | 5 |
| 8 | Column name typo (`order_qt`, `customer_names`) | 7, 8 |
| 9 | Missing `ON` clause in JOIN | 7 |
| 10 | Clause order wrong (`WHERE` after `GROUP BY`) | 8 |
| 11 | `CASE` missing `END` | 9 |

## Key Takeaway

Most SQL bugs are not logic problems. They are syntax hiding in plain sight, and the fix is almost always faster than the search.

---
*AtliQ Technologies | Vishnu Ram Sachin | Data Analyst Intern*
