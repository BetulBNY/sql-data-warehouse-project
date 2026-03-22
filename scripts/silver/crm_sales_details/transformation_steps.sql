-- TRANSFORMATION STEPS

-- NULLIF() Returns Null if two given values are equal; otherwise, it returns the first expression.
-- ABS() Returns absolute value of a number

-- Transformation for Invalid Dates
-- sls_order_dt:
-- 1) Transformation for zeros
SELECT
NULLIF(sls_order_dt ,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0;   
-- 2) Here data length is 8, and date seperated year/month/day

SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LENGTH(CAST(sls_order_dt AS text)) != 8 THEN NULL
	 ELSE TO_DATE(sls_order_dt::text, 'YYYYMMDD') -- In SQL we can't cast integer to date directly. First cast to txt then date.
	 END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LENGTH(CAST(sls_ship_dt AS text)) != 8 THEN NULL
	 ELSE TO_DATE(sls_ship_dt::text, 'YYYYMMDD') -- In SQL we can't cast integer to date directly. First cast to txt then date.
	 END AS sls_ship_dt,	
CASE WHEN sls_due_dt = 0 OR LENGTH(CAST(sls_due_dt AS text)) != 8 THEN NULL
	 ELSE TO_DATE(sls_due_dt::text, 'YYYYMMDD') -- In SQL we can't cast integer to date directly. First cast to txt then date.
	 END AS sls_due_dt,		 
sls_sales,
sls_quantity, 
sls_price
FROM bronze.crm_sales_details;


---------------------------------------------------------
-- 2) TRANSFORM DATA CONSISTENCY: BETWEEN SALES, QUANTITY AND PRICE
SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity, 
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	 THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <= 0 
	 THEN sls_sales / NULLIF(sls_quantity, 0)
	 ELSE sls_price
END AS sls_price	 
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


-- Integrating Into Our Main Query:
SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LENGTH(CAST(sls_order_dt AS text)) != 8 THEN NULL
	 ELSE TO_DATE(sls_order_dt::text, 'YYYYMMDD') -- In SQL we can't cast integer to date directly. First cast to txt then date.
	 END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LENGTH(CAST(sls_ship_dt AS text)) != 8 THEN NULL
	 ELSE TO_DATE(sls_ship_dt::text, 'YYYYMMDD') -- In SQL we can't cast integer to date directly. First cast to txt then date.
	 END AS sls_ship_dt,	
CASE WHEN sls_due_dt = 0 OR LENGTH(CAST(sls_due_dt AS text)) != 8 THEN NULL
	 ELSE TO_DATE(sls_due_dt::text, 'YYYYMMDD') -- In SQL we can't cast integer to date directly. First cast to txt then date.
	 END AS sls_due_dt,		 

CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	 THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE WHEN sls_price IS NULL OR sls_price <= 0 
	 THEN sls_sales / NULLIF(sls_quantity, 0)
	 ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details


















