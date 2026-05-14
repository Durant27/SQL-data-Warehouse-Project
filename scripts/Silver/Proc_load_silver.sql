SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER (TRIM(cst_material_status)) = 'S' THEN 'Single'
	 WHEN UPPER (TRIM(cst_material_status)) = 'M' THEN 'Married'
	 ELSE 'n/a'
END cst_material_status,
CASE WHEN UPPER (TRIM(cst_gndr)) = 'F' THEN 'FEMALE'
	 WHEN UPPER (TRIM(cst_gndr)) = 'm' THEN 'MALE'
	 ELSE 'n/a'
END cst_gndr,
cst_create_date
FROM(
	SELECT
	*,
	ROW_NUMBER () OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS FLAG
	FROM Bronze.crm_cust_info
	WHERE cst_id is NOT NULL 
	)t 
