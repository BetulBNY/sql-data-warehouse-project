-- I will join this table with another data.
-- WARNING: Here I try to avoid using the INNER JOIN. Because if the other table doesn't have all the information about
-- the customers I might lose customers.
-- Always start with the master table.

SELECT * FROM silver.crm_cust_info ci;
SELECT * FROM silver.erp_cust_az12;
SELECT * FROM silver.erp_loc_a101;

-- Necessary Columns Selected From Silver Layer
SELECT 
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname , 
	ci.cst_lastname , 
	ci.cst_marital_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.bdate,
	ca.gen,
	la.cntry
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON 		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON		ci.cst_key = la.cid;

-- So I collected all the customer informations that we have from the two source systems.

-- 1) CHECK FOR DUPLICATES:
-- After joining table, check if any duplicates were introduced by the join logic. I will do it using GROUP BY.
SELECT cst_id, COUNT(*) FROM (
		SELECT
		ci.cst_id,
		ci.cst_key,
		ci.cst_firstname , 
		ci.cst_lastname , 
		ci.cst_marital_status,
		ci.cst_gndr,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		la.cntry
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca
	ON 		ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 la
	ON		ci.cst_key = la.cid)t
GROUP BY cst_id
HAVING COUNT(*) > 1;
-- This query try to find out whether we have any duplicates in the primary key.

-- 2) CHECK AND COMPARE 2 GENDER COLUMNS (gen and cst_gndr):
SELECT DISTINCT
	ci.cst_gndr,
	ca.gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON 		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON		ci.cst_key = la.cid;

/*
 gen        cst_gndr
"Female"	"Female"
"Female"	"n/a"
"Male"		"Female"
"Male"		"Male"
"Female"	"Male"
"n/a"		"n/a"
"n/a"		"Male"
"Male"		"n/a"
"n/a"		"Female"

But for those 2 scenerios:
"Male"		"Female",
"Female"	"Male"
What should we do?
We have data but they arre different. We have to experts about it. What is the Master here? Is it CRM system or ERP?
Let's say The Master Source of Customer Data is CRM.
That means CRM informations are more accurate then the ERP information.

*/




