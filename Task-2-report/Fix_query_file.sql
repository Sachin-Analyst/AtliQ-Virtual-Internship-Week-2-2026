--- 1 
-- How many unique customers are in the city of 'Surat'?

SELECT DISTINCT(COUNT(customer_id)) AS unique_customers
FROM dim_customers
WHERE city LIKE "Surat";

SELECT DISTINCT(COUNT(customer_id)) AS unique_customers
FROM dim_customers
WHERE city = "Surat";

--- 2 
-- What are the minimum and maximum order quantities for each product?

SELECT 
	dp.product_id,
    dp.product_name,
    dp.category,
    MIN(fol.order_qty) AS min_order_qty,
    MAX(fol.order_qty) AS max_order_qty
FROM fact_order_lines fol
JOIN dim_products dp
ON dp.product_id = fol.product_id
GROUP BY dp.product_id;

--- 3 
-- Generate a report with month_name 
-- and number of unfullfilled_orders(i.e order_qty - delivery_qty) in that respective month

SELECT 
        MONTHNAME(order_placement_date) as month_name, 
        SUM(order_qty-delivery_qty) AS unfullfilled_orders
FROM fact_order_lines
GROUP By MONTHNAME(order_placement_date)
ORDER BY unfullfilled_orders DESC; 

--- 4 
-- What is the percentage breakdown of order_qty by category?  
-- The final output includes the following fields
-- category
-- order_qty_pct.

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
		ORDER BY order_qty_pct DESC;


--- 5 
-- Generate a report that includes 
-- the customer ID, customer name, ontime_target_pct, and percentage_category. 

SELECT 
        c.customer_id,
        c.customer_name,
        t.ontime_target_pct,
    CASE 
                WHEN t.ontime_target_pct > 90 THEN 'Above 90'
                WHEN t.ontime_target_pct > 80 THEN 'Above 80'
                WHEN t.ontime_target_pct > 70 THEN 'Above 70'
        ELSE 'Below 70'
        END AS  percentage_category
 FROM gdb080.dim_targets_orders t
 JOIN gdb080.dim_customers c
 ON t.customer_id = c.customer_id;

--- 6 
-- Generate a report that lists all the product categories, 
--  along with the product names and total count of products in each category.
--  The output should have three columns: 
--  category, products, and product_count.

SELECT category, GROUP_CONCAT(product_name) AS products, 
COUNT(*) AS product_count
FROM gdb080.dim_products
GROUP BY category;

--- 7 
-- What are the top 3 most demanded products in the 'Dairy' category, 
-- and their respective order quantity in millions? 
-- The final output includes the following fields:
--            - product name
--            - order_qty_mln. 

SELECT 
        p.product_name,
        ROUND(SUM(f.order_qty) / 1000000,2) AS order_qty_mln
FROM gdb080.dim_products p
JOIN gdb080.fact_order_lines f
ON p.product_id = f.product_id
WHERE p.category = 'Dairy'
GROUP BY p.product_name
ORDER BY order_qty_mln DESC
LIMIT 3;


--- 8 
-- Calculate the OTIF % for a customer named Vijay Stores
-- The final output should contain these fields,
--                customer_name
--                OTIF_percentage

SELECT 
        c.customer_name,
        ROUND((SUM(f.otif) / COUNT(f.order_id) * 100),2) AS     
        OTIF_percentage
FROM gdb080.fact_orders_aggregate f
JOIN gdb080.dim_customers c 
ON c.customer_id = f.customer_id
WHERE c.customer_name = "Vijay Stores"
GROUP BY c.customer_name;

--- 9 
-- What is the percentage of 'in full' for each product and which product has the highest percentage, 
-- based on the data from the 'fact_order_lines' and 'dim_products' tables?

WITH product_if_target AS (
    SELECT 
        p.product_name,
        SUM(CASE WHEN f.in_full = 1 THEN 1 ELSE 0 END ) AS if_count,
        COUNT(f.order_id) AS total_count
    FROM 
        gdb080.fact_order_lines f
        JOIN gdb080.dim_products p ON p.product_id = f.product_id
    GROUP BY p.product_name
)
SELECT 
    product_name,
    ROUND(if_count / total_count * 100, 2) AS IF_percentage
FROM 
    product_if_target
ORDER BY IF_percentage DESC;
