-- =====================================================
-- SILVER LAYER: Customer Information Data Cleaning
-- =====================================================
-- Purpose: Transform and load cleaned customer data from Bronze to Silver layer
-- Transformations: Trim whitespace, standardize codes, remove duplicates
-- =====================================================

INSERT INTO Silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)

-- Main SELECT statement to retrieve and transform data
SELECT
    cst_id,
    cst_key,
    
    -- Remove leading and trailing whitespace from first name
    TRIM(cst_firstname) AS cst_firstname,
    
    -- Remove leading and trailing whitespace from last name
    TRIM(cst_lastname) AS cst_lastname,
    
    -- Standardize marital status codes to readable values
    -- S = Single, M = Married, all other values = n/a
    CASE 
        WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END AS cst_marital_status,
    
    -- Standardize gender codes to uppercase readable values
    -- F = FEMALE, M = MALE, all other values = n/a
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'FEMALE'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'MALE'
        ELSE 'n/a'
    END AS cst_gndr,
    
    -- Keep original creation date for audit trail
    cst_create_date

FROM (
    -- Subquery: Remove duplicate customer records
    -- Using ROW_NUMBER to identify the most recent record per customer ID
    SELECT
        *,
        -- Flag records: 1 = most recent, 2+ = duplicates to exclude
        -- Partitions by customer ID and orders by creation date (newest first)
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS FLAG
    FROM 
        Bronze.crm_cust_info
) AS t

-- Filter: Keep only the most recent record for each customer (FLAG = 1)
WHERE FLAG = 1
