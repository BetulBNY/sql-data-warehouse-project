-- TEST

-- TEST 1: Check Foreing Key Integrity (Dimensions)
-- Check if all dimension tables can successfully join to the fact table.

SELECT * FROM 
gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

SELECT * FROM 
gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE p.product_key IS NULL;