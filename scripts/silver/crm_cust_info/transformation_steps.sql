-- TRANSFORMATION 1's STEPS
-- Write Queries That is Doing the data transformation and Data Cleansing

-- 1) CHECK DUPLICATED VALUES
-- Ensure only one record per entity by identifying and retaining the most relevant row.
SELECT * FROM bronze.crm_cust_info
WHERE cst_id = 29466;
	/*
	We are checking the timestamp or date value to help us.
	When I checked, the last row was the newest one, and the others were older.
	
	If I have to pick one of those rows, I would choose the latest one,
	because it holds the most up-to-date information.
	
	The next step is to rank the values based on the create date
	and select only the highest one.
	*/
	
-- VER 1: Subquery Version
SELECT * FROM 
	(SELECT *, 
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last -- Burada dediğim şey :Her müşteri için en güncel kaydı 1 yap, diğerlerini sırala
	FROM bronze.crm_cust_info )t
	WHERE flag_last = 1; -- Select only unique records and remove duplicates


-- VER 2: CTE (Common Table Expression) Version
WITH ranked AS (
    SELECT *, 
    ROW_NUMBER() OVER (
        PARTITION BY cst_id 
        ORDER BY cst_create_date DESC
    ) AS flag_last
    FROM bronze.crm_cust_info
)
SELECT *
FROM ranked
WHERE flag_last = 1 AND cst_id = 29466;  -- Check if it works

--------------------------------------------------------------------------------------------------------

-- 2) QUALITY CHECK:
-- Check for unwanted spaces in string values
-- Expectation: No Result

SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname , 
TRIM(cst_lastname) as cst_lastname , 
cst_marital_status,
cst_gndr,
cst_create_date
FROM (SELECT *, 
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last -- Burada dediğim şey :Her müşteri için en güncel kaydı 1 yap, diğerlerini sırala
	FROM bronze.crm_cust_info )t
	WHERE flag_last = 1;



-- 3) DATA STANDARDIZATION & CONSISTENCY:

SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname , 
TRIM(cst_lastname) as cst_lastname , 
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	 ELSE 'n/a'
END cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	 ELSE 'n/a'
END cst_gndr,	 
cst_create_date
FROM (SELECT *, 
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last -- What I mean here: For each customer, assign 1 to the most recent record and rank the others.
	WHERE flag_last = 1;

-- 4) INSERT TRANSFORMED DATA TO SILVER LAYER:

INSERT INTO silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname , 
	cst_lastname , 
	cst_marital_status,
	cst_gndr,
	cst_create_date
)
SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname , 
	TRIM(cst_lastname) as cst_lastname , 
	CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		 ELSE 'n/a'
	END cst_marital_status,
	CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		 ELSE 'n/a'
	END cst_gndr,	 
	cst_create_date
	FROM (SELECT *, 
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last -- Burada dediğim şey :Her müşteri için en güncel kaydı 1 yap, diğerlerini sırala
		FROM bronze.crm_cust_info )t
WHERE flag_last = 1;

/*
LOGIC:

1) Extract data from the Bronze table

2) Use a window function to select the most recent record

3) Clean the data (TRIM, CASE, etc.)

4) Insert the result into the Silver table

This represents an ETL / ELT pipeline step:

Extract → get data from Bronze
Transform → clean and deduplicate
Load → insert into Silver
*/
