-- CHECKING QUALITY OF BRONZE LAYER
-- 1) CHECK ID'S
SELECT 
cid,
bdate,
gen
FROM bronze.erp_cust_az12
WHERE cid LIKE '%AW00011000';

-- Checking id's from crm_cust_info
SELECT * FROM silver.crm_cust_info;

-- NASAW00011000 I need to clean 'NAS' part from id's in order to connect to crm_cust_info table.
--------------------------------------------------------------------------------------------------------
-- 2) CHECK OUT OF RANGE DATES
-- Check for very old and future dates.
SELECT DISTINCT 
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > CURRENT_DATE;

--------------------------------------------------------------------------------------------------------
-- 3) CHECK DATA STANDARDIZATION & CONSISTENCY
SELECT DISTINCT
gen
FROM bronze.erp_cust_az12;

/*
-- Output:
"F "
" "
"M "
"Male"
"M"
"Female"
"F"
I need to clean up all those informations in order to have only 3 values:
Male, Female, Not Available
*/

SELECT DISTINCT
gen,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	 ELSE 'n/a'
END AS gen	 
FROM bronze.erp_cust_az12





