-- TRANSFORMATION STEPS:

-- SUBSTRING() Extracts a specific part of a string value.
-- LENGTH() Returns the number of characters in a string.
-- COALESCE() Replaces NULL values witha specified replacement value.
-- LEAD() Access values from the next row within a window. LEAD() → brings the next row
-- LAG() → brings the previous row  
-- CAST() type casting

-- 1) CHECK DUPLICATED VALUES
-- A) CAT_ID PART
SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key,1,5), '-', '_') NOT IN 
(SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2); 
-- I am trying to find any category id that is not available in the second (erp) table.
-- RESULT: CO_PE is not in second table.

-- I am comparing cat_id with erp table: (So, I found a common column, so I can join them.)
SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2; 
-- BUT, IN ERP: CO_RF   IN CRM: CO-RF  --> SO, I used REPLACE func.


-- B) PRD_KEY PART:
SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
FROM bronze.crm_prd_info
WHERE SUBSTRING(prd_key,7,LENGTH(prd_key)) NOT IN   -- Shows products not in sales/order
(SELECT sls_prd_key FROM bronze.crm_sales_details);

-- I am comparing prd_key with crm_sales_details table: (So, I found a common column, so I can join them.)
SELECT sls_prd_key FROM bronze.crm_sales_details;
SELECT sls_prd_key FROM bronze.crm_sales_details WHERE sls_prd_key LIKE 'FR%';


-- C) PRD_NM PART:
SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
FROM bronze.crm_prd_info;

--------------------------------------------------------------------------------------------------------
-- 3) CHECK FOR NULLS OR NEGATIVE NUMBERS:

SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
prd_nm,
COALESCE(prd_cost, 0) AS prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
FROM bronze.crm_prd_info;

--------------------------------------------------------------------------------------------------------
-- 4) DATA STANDARDIZATION & CONSISTENCY:
SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
prd_nm,
COALESCE(prd_cost, 0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
	 WHEN 'M' THEN 'Mountain'
	 WHEN 'R' THEN 'Road'
	 WHEN 'S' THEN 'Other Sales'
	 WHEN 'T' THEN 'Touring'
	 ELSE 'n/a'
END AS prd_line, 
prd_start_dt,
prd_end_dt
FROM bronze.crm_prd_info;

/*
Long Version:
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	 WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	 WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	 ELSE 'n/a'
END AS prd_line, 
*/

--------------------------------------------------------------------------------------------------------
-- 5) CHECK FOR INVALID DATE ORDERS:
-- In SQL if we are adding specific record add want to access another information from another records, for that
-- we have 2 window functions: Lead and Lag.

SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt,
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)- INTERVAL '1 day' AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509');

-- Adding it into our last query:
SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
prd_nm,
COALESCE(prd_cost, 0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
	 WHEN 'M' THEN 'Mountain'
	 WHEN 'R' THEN 'Road'
	 WHEN 'S' THEN 'Other Sales'
	 WHEN 'T' THEN 'Touring'
	 ELSE 'n/a'
END AS prd_line, 
CAST(prd_start_dt AS DATE) AS prd_start_dt,  -- I applied type casting because time value is unnecessary for this column.
CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)- INTERVAL '1 day' AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;
