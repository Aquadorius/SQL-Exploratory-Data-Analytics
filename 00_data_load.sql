/*
PURPOSE: 
This script sets up the DataAnalytics database for loading a star schema data warehouse 
with customer, product, and sales fact tables. The script creates a complete data warehouse 
structure with dimension and fact tables optimized for analytical queries.

WHAT TO DO BEFORE RUNNING THIS SCRIPT:
1. Download all CSV files from this repository to your local machine
2. Update the file paths in the BULK INSERT statements below to match your local directory
3. Ensure your SQL Server login has bulk insert permissions
4. Make sure the CSV files don't contain the text "NULL" - replace with actual empty cells if needed
5. Verify SQL Server service is running and you can connect via SSMS

PREREQUISITES:
- SQL Server 2016 or later (supports CREATE OR ALTER syntax)
- SQL Server Management Studio (SSMS)
- Bulk insert permissions on your SQL Server instance
- CSV files: dim_customers.csv, dim_products.csv, fact_sales.csv

HOW TO USE:
1. Open SQL Server Management Studio (SSMS)
2. Connect to your SQL Server instance
3. Copy and paste this entire script
4. Update the file paths in BULK INSERT statements to your local paths
5. Execute the script (F5 or Execute button)
6. Verify data loaded correctly by running SELECT COUNT(*) on each table
*/

USE master;
GO


IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DataAnalytics')
BEGIN
    PRINT ('Database DataAnalytics found. Proceeding to drop...');
    
    -- Step 1: Set database to single user mode to disconnect all users
    ALTER DATABASE DataAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    PRINT ('Database set to single user mode.');
    
    -- Step 2: Drop the database
    DROP DATABASE DataAnalytics;
    PRINT ('Database DataAnalytics dropped successfully.');
END
ELSE
BEGIN
    PRINT ('Database DataAnalytics does not exist.');
END
GO
-- Step 3: Create the database
CREATE DATABASE DataAnalytics;
GO

-- Drop table if it already exists
IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
    DROP TABLE gold.fact_sales;
GO
-- Drop table if it already exists
IF OBJECT_ID('gold.dim_customers', 'U') IS NOT NULL
    DROP TABLE gold.dim_customers;
GO
-- Drop table if it already exists
IF OBJECT_ID('gold.dim_products', 'U') IS NOT NULL
    DROP TABLE gold.dim_products;
GO
DROP SCHEMA gold;
GO

CREATE SCHEMA gold;

GO



IF OBJECT_ID('gold.dim_customers', 'U') IS NOT NULL
    DROP TABLE gold.dim_customers;
GO
-- Create the gold.dim_customers table
CREATE TABLE gold.dim_customers (
    customer_key INT PRIMARY KEY,
    customer_id INT NULL,
    customer_number NVARCHAR(50) NULL,
    first_name NVARCHAR(50) NULL,
    last_name NVARCHAR(50) NULL,
    country NVARCHAR(50) NULL,
    marital_status NVARCHAR(20) NULL,
    gender NVARCHAR(10) NULL,
    birth_date DATE ,
    create_date DATE 
);
GO

-- Drop table if it already exists
IF OBJECT_ID('gold.dim_products', 'U') IS NOT NULL
    DROP TABLE gold.dim_products;
GO
-- Create the gold.dim_products table
CREATE TABLE gold.dim_products (
    product_key INT PRIMARY KEY,
    product_id INT NULL,
    product_number NVARCHAR(50) NULL,
    product_name NVARCHAR(100) NULL,
    category_id NVARCHAR(20) NULL,
    category NVARCHAR(50) NULL,
    subcategory NVARCHAR(50) NULL,
    maintenance NVARCHAR(10) NULL,
    cost INT NULL,
    product_line NVARCHAR(50) NULL,
    start_date DATE NULL,
    end_date DATE NULL
);
GO


-- Drop table if it already exists
IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
    DROP TABLE gold.fact_sales;

-- Create the gold.fact_sales table
CREATE TABLE gold.fact_sales (
    order_number NVARCHAR(20) NULL,
    customer_key INT NULL,
    product_key INT NULL,
    order_date DATE NULL,
    ship_date DATE NULL,
    due_date DATE NULL,
    sales INT NULL,
    quantity INT NULL,
    price INT NULL
);
GO



TRUNCATE TABLE gold.dim_customers;
GO
	
BULK INSERT gold.dim_customers
FROM 'C:\Users\Elite 1040 G5\Downloads\datasets\dim_customers.csv'
WITH(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK  
);
GO

TRUNCATE TABLE gold.dim_customers;
GO
	
BULK INSERT gold.dim_products
FROM 'C:\Users\Elite 1040 G5\Downloads\datasets\dim_products.csv'
WITH(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK  
);
GO

TRUNCATE TABLE gold.dim_customers;
GO
	
BULK INSERT gold.fact_sales
FROM 'C:\Users\Elite 1040 G5\Downloads\datasets\fact_sales.csv'
WITH(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK  
);
