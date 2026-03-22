-- BRONZE QUALITY CHECKS

SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt, 
sls_sales,
sls_quantity, sls_price
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num); 


-- 1) CHECK UNWANTED SPACES
--sls_ord_num: 
SELECT * 
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num); 
--------------------------------------------------
-- sls_prd_key, sls_cust_id are keys and id's in order to connect to the other tables.
-- Checking integrity of columns:
SELECT * 
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);

SELECT * 
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);
-- We can connect them with other tables, we don't need any transformations for them.
---------------------------------------------------------
-- 2) CHECK FOR INVALID DATES
-- Int to Date	
-- Negative numbers or zeros can't be cast to a date.
SELECT sls_order_dt 
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0;           -- ! There is zeros

-- Check length of data
SELECT sls_order_dt 
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LENGTH(CAST(sls_order_dt AS text)) != 8; 

-- Check for outliers by validating the boundaries of the date range. 
SELECT sls_order_dt 
FROM bronze.crm_sales_details
WHERE sls_order_dt >20500101 OR sls_order_dt < 19000101;

-- All Checks Together for sls_order_dt:
SELECT sls_order_dt 
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
OR LENGTH(CAST(sls_order_dt AS text)) != 8
OR sls_order_dt >20500101
OR sls_order_dt < 19000101;

-- All Checks Together for sls_ship_dt:
SELECT sls_ship_dt 
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 
OR LENGTH(CAST(sls_ship_dt AS text)) != 8
OR sls_ship_dt >20500101
OR sls_ship_dt < 19000101;

-- All Checks Together for sls_due_dt:
SELECT sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
OR LENGTH(CAST(sls_due_dt AS text)) != 8
OR sls_due_dt >20500101
OR sls_due_dt < 19000101;
---------------------------------------------------------
-- 3) CHECK FOR INVALID DATE ORDERS
-- Order date must always be earlier than the Shipping Date or Due Date. Because its makes no sense if we are delivering an item without an order.	
SELECT * 
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR  sls_order_dt > sls_due_dt;

---------------------------------------------------------
-- 4) CHECK DATA CONSISTENCY: BETWEEN SALES, QUANTITY AND PRICE
-- sls_sales, sls_quantity, sls_price all those informations connected to each others. 
-- BUSINESS RULES:
-- TOTAL(Sales) = Quantity * Price
-- Negative, zeros, nulls are not allowed!

SELECT DISTINCT
sls_sales,
sls_quantity, 
sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-- When we check it quantity is better, there is no zeros or negatives but situation for sales and price vice versa.

-- SOLUTION 1: Data Issues will be fixed direct in source system.
-- SOLUTION 2: Data Issues has to be fixed in data warehouse.

-- RULES: 
-- 1. If Sales is negative, zero or null, derive it using Quantity and Price.
-- 2. If Price is zero or null, calculate it using Sales and Quantity.
-- 3. If Price is negative, convert it to a positive value.






































