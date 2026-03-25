-- CHECKING QUALITY OF BRONZE LAYER
SELECT
id,
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2;

SELECT * FROM silver.crm_prd_info;

-- 1) QUALITY CHECK:
-- Check for unwanted spaces in string values
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance) ;
-- There is no unwanted spaces in this table.

--------------------------------------------------------------------------------------------------------
-- 2) DATA STANDARDIZATION & CONSISTENCY:
-- cat:
SELECT DISTINCT
cat
FROM bronze.erp_px_cat_g1v2;

-- subcat;
SELECT DISTINCT
subcat
FROM bronze.erp_px_cat_g1v2;

-- maintenance:
SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_g1v2;

--======================================================================================================
-- CHECKING QUALITY OF SILVER LAYER
SELECT * FROM silver.erp_px_cat_g1v2;


