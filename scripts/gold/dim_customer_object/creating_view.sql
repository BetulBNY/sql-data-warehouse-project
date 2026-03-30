-- TRANSFORMATION STEPS

-- 1) INTEGRATING 2 SOURCE SYSTEMS IN ONE (DATA INTEGRATION)
--TRANSFORMING 2 GENDER COLUMNS (gen and cst_gndr)
SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master of gender Info
		 ELSE COALESCE(ca.gen, 'n/a')
	END AS new_gen	 
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON 		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON		ci.cst_key = la.cid;

-- LAST VERSION OF TABLE:
SELECT 
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname , 
	ci.cst_lastname , 
	ci.cst_marital_status,
	ci.cst_create_date,
	ca.bdate,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master of gender Info
		 ELSE COALESCE(ca.gen, 'n/a')
	END AS new_gen,
	la.cntry
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON 		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON		ci.cst_key = la.cid;

-- Here I took 3 tables and put it 1 object.

-- 2) RENAME COLUMNS TO FRIENDLY, MEANINGFUL NAMES
-- Rule in the Gold Layer is using friendly names. 

SELECT 
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name, 
	ci.cst_lastname AS last_name, 
	ci.cst_marital_status AS marital_status,
	ci.cst_create_date AS create_date,
	ca.bdate AS birthdate,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master of gender Info
		 ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	la.cntry AS country
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON 		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON		ci.cst_key = la.cid;

-- 3) SORT THE COLUMNS INTO LOGICAL GROUPS TO IMPROVE READABILITY
SELECT 
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name, 
	ci.cst_lastname AS last_name, 
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master of gender Info
		 ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON 		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON		ci.cst_key = la.cid;


-- 4) DETERMINING TYPE OF THE TABLE (FACT OR DIMENSION)
-- THIS IS DIMENSION TABLE:
-- Because here we have descriptions about customers. All those columns are describing the customer information. 
-- We don't have transactions or events or any measures.
-- So this is dimension

-- If we are creating new dimension we need always primary key for dimension. 
-- Those primary keys we call them SURROGATE KEY(System generated unique identifier assigned to each record in a table.)
-- Surrogate key is not bussiness key, it has no meaning and no one in the bussiness knows about it. 
-- Only use it in order to connect our data model.

-- How to create SURROGATE KEYS:
-- 1) DDL- based generation.
-- 2) Query-based using Window function(Row_Number)

SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name, 
	ci.cst_lastname AS last_name, 
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master of gender Info
		 ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON 		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON		ci.cst_key = la.cid;


-- 5) CREATING VIEW OBJECT
CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name, 
	ci.cst_lastname AS last_name, 
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master of gender Info
		 ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON 		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON		ci.cst_key = la.cid;
