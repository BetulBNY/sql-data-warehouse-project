-- Inserting data to tables
-- TABLE 1: bronze.crm_cust_info
-- To avoid inserting the same data twice, truncate the table before loading the data.
-- First, make table empty
TRUNCATE TABLE bronze.crm_cust_info;
-- Second, load the data from scratch.
COPY bronze.crm_cust_info
FROM 'C:/Users/betus/Desktop/data-engineering/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM bronze.crm_cust_info;

SELECT COUNT(*) FROM bronze.crm_cust_info;


-- TABLE 2: bronze.crm_prd_info
TRUNCATE TABLE bronze.crm_prd_info;

COPY bronze.crm_prd_info
FROM 'C:/Users/betus/Desktop/data-engineering/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM bronze.crm_prd_info;
SELECT COUNT(*) FROM bronze.crm_cust_info;

-- TABLE 3: bronze.crm_sales_details
TRUNCATE TABLE bronze.crm_sales_details;

COPY bronze.crm_sales_details
FROM 'C:/Users/betus/Desktop/data-engineering/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM bronze.crm_sales_details;
SELECT COUNT(*) FROM bronze.crm_sales_details;

-- TABLE 4: bronze.erp_cust_az12
TRUNCATE TABLE bronze.erp_cust_az12;

COPY bronze.erp_cust_az12
FROM 'C:/Users/betus/Desktop/data-engineering/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM bronze.erp_cust_az12;
SELECT COUNT(*) FROM bronze.erp_cust_az12;

-- TABLE 5: bronze.erp_loc_a101
TRUNCATE TABLE bronze.erp_loc_a101;

COPY bronze.erp_loc_a101
FROM 'C:/Users/betus/Desktop/data-engineering/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM bronze.erp_loc_a101;
SELECT COUNT(*) FROM bronze.erp_loc_a101;

-- TABLE 6: bronze.erp_px_cat_g1v2
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

COPY bronze.erp_px_cat_g1v2
FROM 'C:/Users/betus/Desktop/data-engineering/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM bronze.erp_px_cat_g1v2;
SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;
