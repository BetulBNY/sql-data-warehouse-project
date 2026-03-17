-- CHECKING QUALITY OF BRONZE LAYER

SELECT * FROM bronze.crm_cust_info;

-- 1) CHECK DUPLICATED VALUES
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result

SELECT cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id is Null;

--------------------------------------------------------------------------------------------------------
-- 2) QUALITY CHECK:
-- Check for unwanted spaces in string values
-- Expectation: No Result

SELECT cst_firstname
FROM bronze.crm_cust_info;

-- cst_firstname : List of all names which have spaces
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname); -- If the original value is not equal to the same after trimming, it means there are spaces.

-- cst_lastname: List of all last names which have spaces
SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname); 

-- cst_gndr:
SELECT cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr); 

--------------------------------------------------------------------------------------------------------
-- 3) DATA STANDARDIZATION & CONSISTENCY CHECK:
-- Check the consistency of values in low cardinality columns (cst_gndr & cst_marital_status )
-- In my data warehouse, I aim 	to store clear and meaningful values rather than using abbreviated terms. 
-- In my data warehouse, I use the default 'n/a' for missing values.

SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;

--------------------------------------------------------------------------------------------------------













