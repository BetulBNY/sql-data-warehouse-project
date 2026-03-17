-- BRONZE QUALITY CHECK
-- 1) CHECK DUPLICATED VALUES
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result

-- prd_id: 
SELECT prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;
-- prd_id is empty. Everything is safe.
-- In prd_key we have a lot of informations. So, I split this string into 2 informations.
--------------------------------------------------------------------------------------------------------
-- 2) QUALITY CHECK:
-- Check for unwanted spaces in string values
-- Expectation: No Result

-- prd_nm:
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);
-- This column is safe, it is not return any result.
--------------------------------------------------------------------------------------------------------
-- 3) CHECK FOR NULLS OR NEGATIVE NUMBERS:
-- Expectation: No Result
-- Check for negative costs, negative prices...

-- prd_cost:
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;
-- We don't have negative values but we have nulls. 
--------------------------------------------------------------------------------------------------------
-- 4) DATA STANDARDIZATION & CONSISTENCY:
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;
--------------------------------------------------------------------------------------------------------
-- 5) CHECK FOR INVALID DATE ORDERS:
SELECT * FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- For this kind of situations:

-- Solution 1: Switch End Date and Start Date.
-- But dates are overlapping. So, end dates first history should be younger then start of the next records.
-- I mean 1st row --> is start : 2008 end: 2010, 2nd row --> start : 2009 end: 2011   NO, I don't want this.
-- I mean 1st row --> is start : 2008 end: 2010, 2nd row --> start : 2011 end: 2014   YES

-- Each record must has a start date.
-- But it is okay to have start without an end date.

-- Solution 2: Derive the End Date From the Start Date.
-- End date = Start Date - 1 of the Next Record.

















