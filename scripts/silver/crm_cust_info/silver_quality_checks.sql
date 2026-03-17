-- CHECKING QUALITY OF SILVER LAYER

-- 1) CHECK DUPLICATED VALUES

SELECT * FROM silver.crm_cust_info;

SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id is Null;

--------------------------------------------------------------------------------------------------------
-- 2) QUALITY CHECK:

SELECT cst_firstname
FROM silver.crm_cust_info;

-- cst_firstname : 
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname); 

-- cst_lastname: 
SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname); 

-- cst_gndr:
SELECT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr); 

--------------------------------------------------------------------------------------------------------
-- 3) DATA STANDARDIZATION & CONSISTENCY CHECK:

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

--------------------------------------------------------------------------------------------------------













