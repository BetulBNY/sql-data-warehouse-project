-- CHECKING QUALITY OF BRONZE LAYER

-- 1) CHECK ID
-- cid has "-" between id's. So, I deleted it for able to match id's with other tables.
SELECT 
cid,
cntry
FROM bronze.erp_loc_a101;

SELECT cst_key FROM silver.crm_cust_info;
--------------------------------------------------------------------------------------------------------
-- 2) CHECK DATA STANDARDIZATION & CONSISTENCY
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101;
/*
OUTPUT:
"Australia"
"Germany"
" "
"US"
"Canada"
"DE"
"   "
"United States"
"USA"
"France"
"  "
"United Kingdom"
*/