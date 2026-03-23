-- CHECKING QUALITY OF SILVER LAYER

-- 1) CHECK OUT OF RANGE DATES
-- Check for very old and future dates.
SELECT DISTINCT 
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > CURRENT_DATE;

--------------------------------------------------------------------------------------------------------
-- 2) CHECK DATA STANDARDIZATION & CONSISTENCY
SELECT DISTINCT
gen
FROM silver.erp_cust_az12;

SELECT * FROM silver.erp_cust_az12;




