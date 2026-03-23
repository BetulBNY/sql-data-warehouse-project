-- TRANSFORMATION 4's STEPS
-- 1) UPDATING ID
SELECT 
CASE WHEN cid  LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
	 ELSE cid
END AS cid,	 
bdate,
gen
FROM bronze.erp_cust_az12;


-- Testing ID:
SELECT 
cid,
CASE WHEN cid  LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
	 ELSE cid
END AS cid,	 
bdate,
gen
FROM bronze.erp_cust_az12
WHERE CASE WHEN cid  LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
	 ELSE cid
END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info);

--------------------------------------------------------------------------------------------------------
-- 2) UPDATING BDATE (OUT OF RANGE DATES)
SELECT 
CASE WHEN cid  LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
	 ELSE cid
END AS cid,	 
CASE WHEN bdate > CURRENT_DATE THEN null
	 ELSE bdate
END AS bdate,
gen
FROM bronze.erp_cust_az12;

--------------------------------------------------------------------------------------------------------
-- 3) UPDATING GEN (DATA STANDARDIZATION & CONSISTENCY)
SELECT 
CASE WHEN cid  LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
	 ELSE cid
END AS cid,	 
CASE WHEN bdate > CURRENT_DATE THEN null
	 ELSE bdate
END AS bdate,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	 ELSE 'n/a'
END AS gen	 	 
FROM bronze.erp_cust_az12;

-- Did I changed anything in the DDL? 
-- I didn't change anything and I didn't introduced any new column or changed data type.


