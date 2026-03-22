-- CHECKING QUALITY OF SILVER LAYER

-- 1) CHECK FOR INVALID DATE ORDERS
-- Order date must always be earlier than the Shipping Date or Due Date. Because its makes no sense if we are delivering an item without an order.	
SELECT * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR  sls_order_dt > sls_due_dt;

---------------------------------------------------------
-- 2) CHECK DATA CONSISTENCY: BETWEEN SALES, QUANTITY AND PRICE
SELECT DISTINCT
sls_sales,
sls_quantity, 
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

SELECT * FROM silver.crm_sales_details;