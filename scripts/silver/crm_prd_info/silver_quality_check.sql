-- CHECKING QUALITY OF SILVER LAYER

-- 1) CHECK DUPLICATED VALUES
-- prd_id: 
SELECT prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;
--------------------------------------------------------------------------------------------------------
-- 2) QUALITY CHECK:
-- prd_nm:
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);
--------------------------------------------------------------------------------------------------------
-- 3) CHECK FOR NULLS OR NEGATIVE NUMBERS:
-- prd_cost:
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;
--------------------------------------------------------------------------------------------------------
-- 4) DATA STANDARDIZATION & CONSISTENCY:
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;
--------------------------------------------------------------------------------------------------------
-- 5) CHECK FOR INVALID DATE ORDERS:
SELECT * FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

SELECT * FROM silver.crm_prd_info
