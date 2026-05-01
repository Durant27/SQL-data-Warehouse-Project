#Data Warehouse and Analytics Project
# SQL-data-Warehouse-Project

This project will demonstrate a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. 
Building a modern data warehouse with SQL Server, including ETL Processes, Data Modeling, and analytics 

---This project implements a scalable SQL data warehouse designed to unify disparate data streams into a single, coherent repository. By automating ingestion, transformation, and storage processes, the warehouse supports high-performance queries, reliable reporting, and advanced analytics. Emphasizing best practices in data governance, security, and compliance, it empowers teams with self-service insights and drives data-informed strategies across the organization.

###Specifications 
** DATA SOURCES**: Import data from two source systems (ERP and CRM) provided as CVS Files
** DATA QUALITY**: Cleanse and resolve data quality issues before analysis
** INTEGRATION**: Combine both sources into a single user-friendly data model designed for analytical queries
** SCOPE**: Focus on the latest dataset only; historization of data is not required 
** DOCUMENTATION** Provide clear documentation of the data model to support both business & analytics teams. 

####- BI Analytics & reporting(data analystics)

SQL Data Warehouse ETL Process Overview

This project implements a SQL Server-based data warehouse using a layered ETL architecture. The current ETL process focuses on loading raw source data into the Bronze Layer, which serves as the landing zone for unprocessed data from CRM and ERP systems.

The ETL process is built using a stored procedure:

Bronze.load_bronze

This procedure automates the extraction and loading of CSV files into SQL Server tables using BULK INSERT.

1. ETL Architecture

The warehouse follows a layered data architecture:

Source Systems
     |
     v
CSV Files
     |
     v
Bronze Layer
     |
     v
Silver Layer
     |
     v
Gold Layer
Bronze Layer

The Bronze Layer stores raw data exactly as received from the source systems. Minimal transformation is applied at this stage.

The main goal of this layer is to:

Preserve raw source data
Create a repeatable loading process
Support downstream data cleaning
Provide traceability back to the source files
Separate raw ingestion from transformation logic
2. Source Systems

This ETL process loads data from two main operational systems:

CRM System
ERP System
CRM Source Tables

The CRM data represents customer, product, and sales transaction information.

Source File	Bronze Table	Description
cust_info.csv	Bronze.crm_cust_info	Raw customer profile data
prd_info.csv	Bronze.crm_prd_info	Raw product master data
sales_details.csv	Bronze.crm_sales_details	Raw sales transaction details
ERP Source Tables

The ERP data provides additional customer, location, and product category information.

Source File	Bronze Table	Description
CUST_AZ12.csv	Bronze.erp_cust_az12	ERP customer demographic data
LOC_A101.csv	Bronze.erp_loc_a101	ERP customer location data
PX_CAT_G1V2.csv	Bronze.erp_px_cat_g1v2	ERP product category data
3. Bronze Layer Loading Process

The stored procedure performs a full refresh load for each Bronze table.

For every table, the procedure follows this pattern:

Start Timer
     |
     v
Truncate Target Bronze Table
     |
     v
Bulk Insert CSV File
     |
     v
End Timer
     |
     v
Print Load Duration

Each load step includes:

Table truncation
CSV file ingestion
Runtime tracking
Console logging using PRINT
Error handling using TRY...CATCH
4. Full Refresh Strategy

This ETL process uses a truncate-and-load strategy.

Before each file is loaded, the target Bronze table is cleared:

TRUNCATE TABLE Bronze.crm_cust_info;

Then the CSV file is loaded into the table:

BULK INSERT Bronze.crm_cust_info
FROM 'C:\Users\Jasmi\Downloads\cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
Why this approach is used

This strategy is useful for Bronze Layer ingestion because:

It keeps the process simple and repeatable
It avoids duplicate records during reloads
It ensures the Bronze table always reflects the latest source file
It is easier to debug during development
Limitation

This is not an incremental load. Each execution reloads the entire dataset.

Future improvements may include:

Incremental loading
File audit tracking
Load timestamps
Row count validation
Error tables
Source file archiving
5. Data Lineage

The ETL process maintains clear lineage from source files to Bronze tables.

cust_info.csv
     -> Bronze.crm_cust_info

prd_info.csv
     -> Bronze.crm_prd_info

sales_details.csv
     -> Bronze.crm_sales_details

CUST_AZ12.csv
     -> Bronze.erp_cust_az12

LOC_A101.csv
     -> Bronze.erp_loc_a101

PX_CAT_G1V2.csv
     -> Bronze.erp_px_cat_g1v2

This lineage helps identify where each dataset originated and where it lands in the warehouse.

6. ETL Control Flow

The stored procedure is organized into three main sections:

1. Batch Initialization
2. Source System Loading
3. Batch Completion or Error Handling
Batch Initialization

The procedure starts by declaring timing variables:

DECLARE 
    @start_time DATETIME, 
    @end_time DATETIME, 
    @batch_start_time DATETIME, 
    @batch_end_time DATETIME;

These variables track:

Individual table load duration
Total batch duration
Start and end times for monitoring
7. CRM Load Flow

The first section loads CRM data.

CRM Files
   |
   |-- cust_info.csv
   |       -> Bronze.crm_cust_info
   |
   |-- prd_info.csv
   |       -> Bronze.crm_prd_info
   |
   |-- sales_details.csv
           -> Bronze.crm_sales_details

The CRM data is loaded first because it contains core business entities such as customers, products, and sales transactions.

8. ERP Load Flow

The second section loads ERP data.

ERP Files
   |
   |-- CUST_AZ12.csv
   |       -> Bronze.erp_cust_az12
   |
   |-- LOC_A101.csv
   |       -> Bronze.erp_loc_a101
   |
   |-- PX_CAT_G1V2.csv
           -> Bronze.erp_px_cat_g1v2

ERP data enriches the CRM data by adding demographic, geographic, and category-level information.

9. Logging and Monitoring

The procedure uses PRINT statements to provide execution details.

Example output:

Loading Bronze Layer
Loading CRM Tables
Truncating Table: Bronze.crm_cust_info
Inserting Data Into Table: Bronze.crm_cust_info
Loading duration: 2 seconds

This helps with:

Debugging
Tracking load progress
Measuring performance
Identifying the failed load step

Each table load is timed using:

DATEDIFF(second, @start_time, @end_time)

The total batch duration is also calculated at the end of the procedure.

10. Error Handling

The ETL process uses a TRY...CATCH block to catch failures during loading.

If an error occurs, the procedure prints:

Error message
Error number
Error state
Error line
Batch failure details

Example:

BEGIN CATCH
    PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
    PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR);

    THROW;
END CATCH

The THROW statement re-raises the error so it can be captured by external monitoring, SQL Agent jobs, or future logging tables.

11. Data Flow Diagram
                    +----------------+
                    |   CSV Files    |
                    +----------------+
                            |
                            v
        +---------------------------------------+
        |        Bronze.load_bronze             |
        |  SQL Stored Procedure ETL Process     |
        +---------------------------------------+
                            |
        -------------------------------------------------
        |                                               |
        v                                               v
+-------------------+                         +-------------------+
|    CRM Sources    |                         |    ERP Sources    |
+-------------------+                         +-------------------+
        |                                               |
        v                                               v
+------------------------+                  +------------------------+
| Bronze.crm_cust_info   |                  | Bronze.erp_cust_az12   |
| Bronze.crm_prd_info    |                  | Bronze.erp_loc_a101    |
| Bronze.crm_sales_details|                 | Bronze.erp_px_cat_g1v2 |
+------------------------+                  +------------------------+
                            |
                            v
                  +------------------+
                  |  Silver Layer    |
                  | Data Cleansing   |
                  +------------------+
                            |
                            v
                  +------------------+
                  |   Gold Layer     |
                  | Analytics Model  |
                  +------------------+
12. Purpose of the Bronze Layer

The Bronze Layer is not intended for final reporting.

Instead, it acts as the raw ingestion layer where data is stored before cleansing and transformation.

Downstream layers will handle:

Silver Layer
Data cleaning
Removing duplicates
Standardizing values
Handling nulls
Fixing date formats
Validating business rules
Joining CRM and ERP datasets
Gold Layer
Business-ready tables
Star schema modeling
Fact and dimension tables
Reporting views
Power BI or dashboard consumption
13. Key Features of This ETL Process

This stored procedure includes:

Automated Bronze Layer loading
CRM and ERP source separation
Full refresh strategy
Bulk loading for performance
Table-level duration tracking
Batch-level duration tracking
Error handling with detailed messages
Reusable stored procedure design
Clear data lineage from CSV files to warehouse tables
14. Example Execution

To run the Bronze Layer load:

EXEC Bronze.load_bronze;

This command loads all CRM and ERP source files into their corresponding Bronze tables.

15. Future Enhancements

Future improvements for this ETL pipeline may include:

Add an ETL audit table
Capture row counts before and after loading
Store file names and load timestamps
Add data quality checks
Move file paths into a configuration table
Add incremental loading logic
Add SQL Server Agent scheduling
Archive processed files
Add failure alerting
Add logging for successful and failed loads
Summary

The Bronze.load_bronze stored procedure is the first stage of the data warehouse ETL pipeline. It extracts raw data from CRM and ERP CSV files and loads it into the Bronze Layer using SQL Server BULK INSERT.

This design creates a clean foundation for a modern data warehouse by separating raw ingestion from transformation, improving traceability, and preparing the data for future Silver and Gold Layer processing.
