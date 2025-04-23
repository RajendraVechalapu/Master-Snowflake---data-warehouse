---- VALIDATION_MODE ----
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
  
LIST @COPY_DB.PUBLIC.aws_stage_copy;
  
    
 //Load data using copy command
-- This script performs a COPY operation to load data into the COPY_DB.PUBLIC.ORDERS table.
-- 
-- Key Details:
-- 1. Source: The data is loaded from the external stage `@aws_stage_copy`.
-- 2. File Format: The files are in CSV format with the following specifications:
--    - Field delimiter: Comma (`,`)
--    - Header row: Skips the first row as it contains column headers.
-- 3. Pattern: Only files matching the pattern `.*Order.*` are processed.
-- 4. Validation Mode: The `VALIDATION_MODE = RETURN_ERRORS` option is used to validate the files 
--    without loading data. It returns any errors encountered during validation.
-- 
-- Note: This script is useful for testing and validating the data files before performing an actual load.
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
   VALIDATION_MODE = RETURN_5_ROWS 
   