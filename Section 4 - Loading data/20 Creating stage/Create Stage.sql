// Database to manage stage objects, fileformats etc.

CREATE OR REPLACE DATABASE MANAGE_DB;

CREATE OR REPLACE SCHEMA external_stages;


// Creating external stage

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3'
    credentials=(aws_key_id='ABCD_DUMMY_ID' aws_secret_key='1234abcd_key');


// Description of external stage

DESC STAGE MANAGE_DB.external_stages.aws_stage; 
    
    
// Alter external stage   

ALTER STAGE aws_stage
    SET credentials=(aws_key_id='XYZ_DUMMY_ID' aws_secret_key='987xyz');
    
    
// Publicly accessible staging area    

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3';

// List files in stage

LIST @aws_stage;

LIST @aws_stage/OrderDetails.csv;


-- Step 2: Query the file in the stage using the format
-- Preview top 100 rows from order.csv in the stage
CREATE OR REPLACE FILE FORMAT my_csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 0
  FIELD_DELIMITER = ',';  -- change to ';' if semicolon-separated

-- it does not work
SELECT *
FROM @aws_stage/OrderDetails.csv (FILE_FORMAT => my_csv_format)
LIMIT 1;




//Load data using copy command

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*';

