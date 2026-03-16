/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
		1. Load raw CSV data into Bronze tables.
		2. Avoid duplicate data by truncating tables before load.
		3. Log row counts and load durations per table.
		4. Capture errors and log messages for debugging.
		5. Measure total batch duration for performance monitoring.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL bronze.load_bronze();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
BEGIN
	DECLARE
    start_time TIMESTAMP;
    end_time   TIMESTAMP;
	batch_start_time TIMESTAMP; -- For calculating whole queries(batch)
	batch_end_time TIMESTAMP;
	
	BEGIN  -- TRY…CATCH → BEGIN…EXCEPTION
	batch_start_time := clock_timestamp();
	    RAISE NOTICE '======================================================';
	    RAISE NOTICE 'Loading Bronze Layer';
	    RAISE NOTICE '======================================================';
	
		RAISE NOTICE '------------------------------------------------------';
		RAISE NOTICE 'Loading CRM Tables';
		RAISE NOTICE '------------------------------------------------------';
		
	-- TABLE 1: bronze.crm_cust_info
		start_time := clock_timestamp();
		-- First, make table empty
		RAISE NOTICE '>>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		-- Second, load the data from scratch.
		RAISE NOTICE '>>> Inserting Data Into: bronze.crm_cust_info';
		COPY bronze.crm_cust_info
		FROM 'C:/Users/betus/Desktop/data-engineering/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
		DELIMITER ','
		CSV HEADER;
		
		RAISE NOTICE 'Loaded % rows into crm_cust_info', (SELECT COUNT(*) FROM bronze.crm_cust_info);
		end_time := clock_timestamp();
		
		RAISE NOTICE '>>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
    	RAISE NOTICE '>>-----------------------';
		
	-- TABLE 2: bronze.crm_prd_info
		start_time := clock_timestamp();
		RAISE NOTICE '>>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		
		RAISE NOTICE '>>> Inserting Data Into: bronze.crm_prd_info';
		COPY bronze.crm_prd_info
		FROM 'C:/Users/betus/Desktop/data-engineering/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
		DELIMITER ','
		CSV HEADER;
	
		RAISE NOTICE 'Loaded % rows into crm_prd_info', (SELECT COUNT(*) FROM bronze.crm_prd_info);
		end_time := clock_timestamp();
		
		RAISE NOTICE '>>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
    	RAISE NOTICE '>>-----------------------';
		
	-- TABLE 3: bronze.crm_sales_details
		start_time := clock_timestamp();
		RAISE NOTICE '>>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
	
		RAISE NOTICE '>>> Inserting Data Into: bronze.crm_sales_details';
		COPY bronze.crm_sales_details
		FROM 'C:/Users/betus/Desktop/data-engineering/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
		DELIMITER ','
		CSV HEADER;
	
		RAISE NOTICE 'Loaded % rows into crm_sales_details', (SELECT COUNT(*) FROM bronze.crm_sales_details);
		end_time := clock_timestamp();
		
		RAISE NOTICE '>>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
    	RAISE NOTICE '>>-----------------------';
	
		RAISE NOTICE '------------------------------------------------------';
		RAISE NOTICE 'Loading ERP Tables';
		RAISE NOTICE '------------------------------------------------------';
		
	-- TABLE 4: bronze.erp_cust_az12
		start_time := clock_timestamp();
		RAISE NOTICE '>>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		
		RAISE NOTICE '>>> Inserting Data Into: bronze.erp_cust_az12';
		COPY bronze.erp_cust_az12
		FROM 'C:/Users/betus/Desktop/data-engineering/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
		DELIMITER ','
		CSV HEADER;
	
		RAISE NOTICE 'Loaded % rows into erp_cust_az12', (SELECT COUNT(*) FROM bronze.erp_cust_az12);
		end_time := clock_timestamp();
		
		RAISE NOTICE '>>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
    	RAISE NOTICE '>>-----------------------';
		
	-- TABLE 5: bronze.erp_loc_a101
		start_time := clock_timestamp();
		RAISE NOTICE '>>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		
		RAISE NOTICE '>>> Inserting Data Into: bronze.erp_loc_a101';
		COPY bronze.erp_loc_a101
		FROM 'C:/Users/betus/Desktop/data-engineering/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
		DELIMITER ','
		CSV HEADER;
	
		RAISE NOTICE 'Loaded % rows into erp_loc_a101', (SELECT COUNT(*) FROM bronze.erp_loc_a101);
		end_time := clock_timestamp();
		
		RAISE NOTICE '>>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
    	RAISE NOTICE '>>-----------------------';
		
	-- TABLE 6: bronze.erp_px_cat_g1v2
		start_time := clock_timestamp();
		RAISE NOTICE '>>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	
		RAISE NOTICE '>>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		COPY bronze.erp_px_cat_g1v2
		FROM 'C:/Users/betus/Desktop/data-engineering/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
		DELIMITER ','
		CSV HEADER;
		
		RAISE NOTICE 'Loaded % rows into erp_px_cat_g1v2', (SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2);
		end_time := clock_timestamp();
		
		RAISE NOTICE '>>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
    	RAISE NOTICE '>>-----------------------';

		batch_end_time := clock_timestamp();
		RAISE NOTICE '=============================================';
		RAISE NOTICE 'Loading Bronze Layer is Completed';
		RAISE NOTICE '>>> Total Load Duration: % seconds', EXTRACT(EPOCH FROM (batch_end_time - batch_start_time));
		RAISE NOTICE '=============================================';
		
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '=============================================';
            RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
            RAISE NOTICE 'Error Message: %', SQLERRM;
			RAISE NOTICE 'SQLSTATE: %', SQLSTATE;
            RAISE NOTICE '=============================================';
    END;

END;
$$;