/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/
--Five products generating the highest revenue
SELECT TOP 5
p.product_id,
p.product_key,
product_name,
SUM(s.sales)  revenue,
ROW_NUMBER()OVER(ORDER BY SUM(s.sales) desc) rnk
FROM gold.dim_products p 
LEFT JOIN gold.fact_sales s 
ON p.product_key=s.product_key
GROUP BY p.product_id,p.product_key,product_name;
--OR
SELECT 
*
FROM(
SELECT
p.product_id,
p.product_key,
product_name,
SUM(s.sales)  revenue,
ROW_NUMBER()OVER(ORDER BY SUM(s.sales) desc) rnk
FROM gold.dim_products p 
LEFT JOIN gold.fact_sales s 
ON p.product_key=s.product_key
GROUP BY p.product_id,p.product_key,product_name
)t
where rnk<=5;


--Five products generating the lowest revenue
SELECT TOP 5
p.product_id,
p.product_key,
product_name,
SUM(s.sales)  revenue,
ROW_NUMBER()OVER(ORDER BY SUM(s.sales) ) rnk
FROM gold.dim_products p 
LEFT JOIN gold.fact_sales s 
ON p.product_key=s.product_key
WHERE s.product_key is NOT NULL--If you don't want products with no orders at all
GROUP BY p.product_id,p.product_key,product_name
ORDER BY revenue


--Find top 10 customers and their details who have generated the highest revenue
SELECT 
*
FROM(
SELECT
c.first_name,
c.last_name,
SUM(s.sales) revenue,
ROW_NUMBER()OVER(ORDER BY sum(s.sales) DESC) rnk
FROM gold.dim_customers c 
LEFT JOIN gold.fact_sales s 
ON c.customer_key=s.customer_key
GROUP BY c.first_name,c.last_name
)t
where rnk<=10;

--The 3 customers with the fewest orders placed
SELECT 
*
FROM(
SELECT
c.customer_key,
c.first_name,
c.last_name,
COUNT(s.customer_key) total_orders,
ROW_NUMBER()OVER(ORDER BY COUNT(s.customer_key)) rnk
FROM gold.dim_customers c 
LEFT JOIN gold.fact_sales s 
ON c.customer_key=s.customer_key
GROUP BY c.first_name,c.last_name,c.customer_key
)t
where rnk<=3;
