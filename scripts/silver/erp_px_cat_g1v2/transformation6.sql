-- TRANSFORMATION 6

-- NOTE: Before inserting any data we have to make sure that we are truncating and emptying the table.
TRUNCATE TABLE silver.erp_px_cat_g1v2;

INSERT INTO silver.erp_px_cat_g1v2
(id, cat, subcat, maintenance)
SELECT
id,
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2;