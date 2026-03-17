-- UPDATING CRM_PRD_INFO_TABLE
-- I have to update table because I changed data type(date), also here there is no cat_id.
-- So, I do some modifications to the DDL.

DROP TABLE IF EXISTS silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
    prd_id INT,
	cat_id VARCHAR(50),  -- ADDED!
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATE, -- UPDATED!
    prd_end_dt DATE,   -- UPDATED!
	dwh_create_date DATE DEFAULT CURRENT_DATE
);