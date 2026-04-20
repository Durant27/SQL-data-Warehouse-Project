
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from CSV files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================

TRUNCATE TABLE bronze.crm_cust_info

BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\Jasmi\Downloads\cust_info.csv'
WITH ( 
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK

);

SELECT COUNT (*)  FROM bronze.crm_cust_info 
===================================================

BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\Jasmi\Downloads\prd_info.csv'
WITH ( 
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK

);
======================================================
BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\Jasmi\Downloads\sales_details.csv'
WITH ( 
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK

);

========================================================


BULK INSERT Bronze.erp_cust_az12
FROM 'C:\Users\Jasmi\Downloads\CUST_AZ12.csv'
WITH ( 
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK

);

============================================================



BULK INSERT Bronze.erp_loc_a101
FROM 'C:\Users\Jasmi\Downloads\LOC_A101.csv'
WITH ( 
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK

);
===================================================================

