

---- SIZE_LIMIT ----

// Prepare database & table
CREATE OR REPLACE DATABASE COPY_DB;

CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));
    
    
// Prepare stage object
CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
    url='s3://snowflakebucket-copyoption/size/';
    
    
// List files in stage
LIST @aws_stage_copy;


//Load data using copy command
-- This script performs a COPY INTO operation to load data into the COPY_DB.PUBLIC.ORDERS table.
-- 
-- Key Details:
-- 1. Source: Data is loaded from the external stage `@aws_stage_copy`.
-- 2. File Format: The files are in CSV format with the following properties:
--    - Field delimiter: Comma (`,`)
--    - Header row: Skips the first row as it is assumed to be a header.
-- 3. Pattern: Only files matching the regex pattern '.*Order.*' will be processed.
-- 4. SIZE_LIMIT: Limits the size of each file to 20,000 bytes for processing.
-- 
-- Note: Ensure that the stage `@aws_stage_copy` is properly configured and accessible.
--Only process files up to this size per file chunk — and skip anything above that size limit.
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    SIZE_LIMIT=50; -- 50 KB

SELECT * FROM COPY_DB.PUBLIC.ORDERS;
