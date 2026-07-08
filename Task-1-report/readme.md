# Task 1 Order & Delivery Quantity Variance Analysis

*Tools Used:* Power BI, DAX  
*Date:* 08.07.2026

---

## Objective
Compare recorded order and delivery quantities against benchmark values, and answer specific business questions using the resulting variance data.

Two source tables were used:
- `FACT_ORDERS` recorded (actual) order and delivery quantities
- `BENCHMARKS` expected/benchmark order and delivery quantities

---

## DAX Measures — Order Quantity

```dax
BM_ORDER_QTY = SUM(BENCHMARKS[TOTAL_ORDER_QUANTITY])

RECORDED_ORDER_QTY = SUM(FACT_ORDERS[ORDER_QTY])

DIFF_ORDER_QTY = ABS([RECORDED_ORDER_QTY] - [BM_ORDER_QTY])

ORDER_%_BM = ABS([RECORDED_ORDER_QTY] - [BM_ORDER_QTY]) / [BM_ORDER_QTY] * 100
```

## DAX Measures — Delivery Quantity

```dax
BM_DELIVERY_QTY = SUM(BENCHMARKS[TOTAL_DELIVERY_QUANTITY])

RECORDED_DELIVERY_QTY = SUM(FACT_ORDERS[DELIVERY_QTY])

DIFF_DELIVERY_QTY = ABS([RECORDED_DELIVERY_QTY] - [BM_DELIVERY_QTY])

DELIVERY_%_BM = ABS([RECORDED_DELIVERY_QTY] - [BM_DELIVERY_QTY]) / [BM_DELIVERY_QTY] * 100
```

---

## Dim_Month Table

`FACT_ORDERS` and `BENCHMARKS` had no shared date dimension, so a new table was created via **Modeling > New Table**:

```dax
Dim_Month =
    ADDCOLUMNS(
        DISTINCT(UNION(VALUES(FACT_ORDERS[MMM_YY]), VALUES(BENCHMARKS[MMM_YY]))),
        "MONTH_SORT",
        SWITCH(
            [MMM_YY],
            "MAR_22", 1,
            "APR_22", 2,
            "MAY_22", 3,
            "JUN_22", 4,
            "JUL_22", 5,
            "AUG_22", 6
        )
    )
```

**Approach note:** `MONTH_SORT` was first attempted as a separate calculated column referencing `mmm_yy`. Setting `mmm_yy`'s "Sort by Column" property to `MONTH_SORT` threw a circular dependency error, since Power BI detected a loop (`mmm_yy` > sorted by > `MONTH_SORT` > calculated from → `mmm_yy`). The fix was to generate both columns together inside the same `ADDCOLUMNS` table expression, rather than layering the sort column on afterward. This removed the dependency loop and allowed `mmm_yy` to sort chronologically instead of alphabetically.

**Common columns pulled from related tables:**

| Column | Source Table |
|---|---|
| mmm_yy | Dim_Month |
| customer_name | dim_customer |
| customer_id | dim_customer |
| city | dim_customer |

---

## Business Questions & Answers

**1. Which customer_id has the largest absolute difference between recorded and benchmark order quantity?**  
→ May_22 — Elite Mart — 789903 — Vadodara (Diff: 4,781 | 7.48%)

**2. How many customers in the delivery category have a difference greater than 3% between recorded and benchmark delivery quantity, expressed as a percentage of the benchmark?**  
→ **05**  
*Counted at customer-month level. Lotus Mart (789420) appears twice — in Jun_22 and Jul_22 — as it independently crossed the 3% threshold in both months.*

**3. What is the quantity of orders recorded for "Viveks Stores" in Vadodara during March 2022?**  
→ **73,011**

---

## Key Learnings
- Data here is tracked at a *customer-month level*, not just customer level — the same `customer_id` can appear more than once if it crosses a threshold in different months. When a question asks "how many customers," it's worth being clear whether the count is customer-month instances or unique `customer_id`s.
- Total rows in a Power BI table visual can behave oddly when mixing text and numeric columns — turned off Total rows to keep output matching the expected reference table exactly.
- Sorting on a text-based month column (`mmm_yy`) sorts alphabetically by default, not chronologically — solved by generating a `MONTH_SORT` helper column inside the same table expression as the month column itself, avoiding a circular dependency.
