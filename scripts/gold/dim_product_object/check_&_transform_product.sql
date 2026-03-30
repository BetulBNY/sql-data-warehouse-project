-- 1) FIND LIST OF CURRENT(ACTIVE) PRODUCTS
-- I filtered historical data and stayed only with current data.
-- NOTE: If the end_date is NULL then it is Current Info of the product.
SELECT
pn.prd_id,
pn.cat_id,
pn.prd_key,
pn.prd_nm,
pn.prd_cost,
pn.prd_line,
pn.prd_start_dt
--,pn.prd_end_dt
FROM silver.crm_prd_info pn
WHERE prd_end_dt IS NULL;  -- Fiter out all historical data 

SELECT * FROM silver.erp_px_cat_g1v2;

--------------------------------------------------------------------------------------------------------
-- 2) JOIN crm_prd_info WITH erp_px_cat_g1v2:

SELECT
pn.prd_id,
pn.cat_id,
pn.prd_key,
pn.prd_nm,
pn.prd_cost,
pn.prd_line,
pn.prd_start_dt,
pc.cat,
pc.subcat,
pc.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id 
WHERE prd_end_dt IS NULL; 

--------------------------------------------------------------------------------------------------------
-- 3) QUALITY CHECK 1:
-- Check whether there are multiple records (duplicates) with the same prd_key; if so, identify them.
SELECT prd_key, COUNT(*) FROM(
SELECT
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id 
WHERE prd_end_dt IS NULL)t
GROUP BY prd_key
HAVING COUNT(*) > 1;

-- QUALITY CHECK 2:
-- Do we have same information twice?
-- No

--------------------------------------------------------------------------------------------------------
-- 4) SORT COLUMNS:
-- Sort columns into logical groups to improve readability.
SELECT
	pn.prd_id,
	pn.prd_key,
	pn.prd_nm,
	pn.cat_id,
	pc.cat,
	pc.subcat,
	pc.maintenance,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id 
WHERE prd_end_dt IS NULL;

--------------------------------------------------------------------------------------------------------
-- 5) RENAME COLUMNS:
-- Rename columns to friendly, meaningful
SELECT
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id 
WHERE prd_end_dt IS NULL;

--------------------------------------------------------------------------------------------------------
-- 6) DETERMINING TYPE OF THE TABLE (FACT OR DIMENSION)
-- THIS IS DIMENSION TABLE:
-- Because here we have descriptions about products. All those columns are describing the products information. 
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
ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id 
WHERE prd_end_dt IS NULL;