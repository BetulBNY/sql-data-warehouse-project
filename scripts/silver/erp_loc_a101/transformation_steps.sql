-- TRANSFORMATION 5's STEPS

-- 2) UPDATING ID
SELECT 
REPLACE(cid, '-', '') cid,
cid,
cntry
FROM bronze.erp_loc_a101;

--------------------------------------------------------------------------------------------------------
-- 2) DATA STANDARDIZATION & CONSISTENCY
SELECT 
REPLACE(cid, '-', '') cid,
CASE 
	WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
	WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101;