/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from CSV files to bronze tables.
===============================================================================
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.
*/

CREATE OR ALTER PROCEDURE bronze.load_broze 
AS BEGIN
		TRUNCATE TABLE Bronze.crm_cust_info
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Jasmi\Downloads\cust_info.csv'
		WITH ( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		TRUNCATE TABLE Bronze.crm_prd_info
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Jasmi\Downloads\prd_info.csv'
		WITH ( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		TRUNCATE TABLE Bronze.crm_sales_details
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Jasmi\Downloads\sales_details.csv'
		WITH ( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		TRUNCATE TABLE Bronze.erp_cust_az12
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Jasmi\Downloads\CUST_AZ12.csv'
		WITH ( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK

		);
		TRUNCATE TABLE Bronze.erp_loc_a101
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Jasmi\Downloads\LOC_A101.csv'
		WITH ( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK

		);
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Jasmi\Downloads\erp_px_cat_g1v2.csv'
		WITH ( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
);
END
