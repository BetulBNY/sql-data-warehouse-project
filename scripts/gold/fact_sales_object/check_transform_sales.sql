SELECT * FROM silver.crm_sales_details;
-- For sales information we have only data from CRM, we don't have anything from the ERP. So, we have 
-- only 1 table, we don't have to do any integrations.
SELECT 
sd.sls_ord_num,
sd.sls_prd_key,
sd.sls_cust_id,
sd.sls_order_dt,
sd.sls_ship_dt,
sd.sls_due_dt,
sd.sls_sales,
sd.sls_quantity,
sd.sls_price
FROM silver.crm_sales_details sd;

-- While by looking to those details we have 3 key columns, 3 date columns and 3 measures columns.
-- So, it is connecting multiple connections when we looked at ids(keys).
-- This is exactly a fact table.

-- Fact is connecting multiple dimensions, we have to present in this fact the surrogate keys comes from dimesnions.

-- BUILDING FACT: Use the dimension's surrogate keys instead of IDs to easily connect facts with dimensions.
-- So I will replace sls_prd_key,sls_cust_id columns informations with their surrogate keys that I generated before.
-- In order to do that I have to go and join these 2 dimension order to get surrogate key and
-- we call this process DATA LOOK UP
--------------------------------------------------------------------------------------------------------
-- 1) JOINING WITH DIMENSIONS 
SELECT 
sd.sls_ord_num,
--sd.sls_prd_key,
pr.product_key,
--sd.sls_cust_id,
cu.customer_key,
sd.sls_order_dt,
sd.sls_ship_dt,
sd.sls_due_dt,
sd.sls_sales,
sd.sls_quantity,
sd.sls_price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id;

--------------------------------------------------------------------------------------------------------
-- 2) RENAME COLUMNS:
-- Rename columns to friendly, meaningful
SELECT 
sd.sls_ord_num AS order_number,
pr.product_key,
cu.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales_amount,
sd.sls_quantity AS quantity,
sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id;
--------------------------------------------------------------------------------------------------------
-- 3) SORT COLUMNS:
-- It is fine. They have already ordered logically.

