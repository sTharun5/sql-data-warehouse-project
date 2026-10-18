
USE datawarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    DECLARE
        @start_time       DATETIME,
        @end_time         DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time   DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '==========================================';
        PRINT 'Starting Bronze Layer Full Load';
        PRINT '==========================================';


        -- 1. CRM Customer Information
        PRINT '1. Loading CRM Customer Information...';

        SET @start_time = GETDATE();

        PRINT '   Truncating bronze.crm_cust_info...';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '   Inserting data into bronze.crm_cust_info...';

        BULK INSERT bronze.crm_cust_info
        FROM '/var/opt/mssql/data/datasets/source_crm/cust_info.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '   Time Taken: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';

        PRINT '   Completed: bronze.crm_cust_info';
        PRINT '------------------------------------------';


        -- 2. CRM Product Information
        PRINT '2. Loading CRM Product Information...';

        SET @start_time = GETDATE();

        PRINT '   Truncating bronze.crm_prd_info...';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '   Inserting data into bronze.crm_prd_info...';

        BULK INSERT bronze.crm_prd_info
        FROM '/var/opt/mssql/data/datasets/source_crm/prd_info.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '   Time Taken: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';

        PRINT '   Completed: bronze.crm_prd_info';
        PRINT '------------------------------------------';


        -- 3. CRM Sales Details
        PRINT '3. Loading CRM Sales Details...';

        SET @start_time = GETDATE();

        PRINT '   Truncating bronze.crm_sales_details...';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '   Inserting data into bronze.crm_sales_details...';

        BULK INSERT bronze.crm_sales_details
        FROM '/var/opt/mssql/data/datasets/source_crm/sales_details.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '   Time Taken: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';

        PRINT '   Completed: bronze.crm_sales_details';
        PRINT '------------------------------------------';


        -- 4. ERP Customer Information
        PRINT '4. Loading ERP Customer Information...';

        SET @start_time = GETDATE();

        PRINT '   Truncating bronze.erp_cust_az12...';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '   Inserting data into bronze.erp_cust_az12...';

        BULK INSERT bronze.erp_cust_az12
        FROM '/var/opt/mssql/data/datasets/source_erp/CUST_AZ12.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '   Time Taken: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';

        PRINT '   Completed: bronze.erp_cust_az12';
        PRINT '------------------------------------------';


        -- 5. ERP Location Information
        PRINT '5. Loading ERP Location Information...';

        SET @start_time = GETDATE();

        PRINT '   Truncating bronze.erp_loc_a101...';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '   Inserting data into bronze.erp_loc_a101...';

        BULK INSERT bronze.erp_loc_a101
        FROM '/var/opt/mssql/data/datasets/source_erp/LOC_A101.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '   Time Taken: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';

        PRINT '   Completed: bronze.erp_loc_a101';
        PRINT '------------------------------------------';


        -- 6. ERP Product Category Information
        PRINT '6. Loading ERP Product Category Information...';

        SET @start_time = GETDATE();

        PRINT '   Truncating bronze.erp_px_cat_g1v2...';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '   Inserting data into bronze.erp_px_cat_g1v2...';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/var/opt/mssql/data/datasets/source_erp/PX_CAT_G1V2.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '   Time Taken: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';

        PRINT '   Completed: bronze.erp_px_cat_g1v2';
        PRINT '------------------------------------------';


        -- Total batch duration
        SET @batch_end_time = GETDATE();

        PRINT '==========================================';
        PRINT 'Bronze Layer Full Load Completed Successfully';
        PRINT 'Total Batch Time: '
            + CAST(
                DATEDIFF(SECOND, @batch_start_time, @batch_end_time)
                AS NVARCHAR(10)
            )
            + ' seconds';
        PRINT '==========================================';

    END TRY

    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING BRONZE LOAD';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: '
            + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error State: '
            + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT '==========================================';
    END CATCH
END;
GO
