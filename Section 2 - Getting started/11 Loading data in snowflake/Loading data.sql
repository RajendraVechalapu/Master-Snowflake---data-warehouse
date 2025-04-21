//Creating the table / Meta data

//Check that table is empy
 USE DATABASE OUR_FIRST_DB;


CREATE TABLE "OUR_FIRST_DB"."PUBLIC"."LOAN_PAYMENT" (
  "Loan_ID" STRING,
  "loan_status" STRING,
  "Principal" STRING,
  "terms" STRING,
  "effective_date" STRING,
  "due_date" STRING,
  "paid_off_time" STRING,
  "past_due_days" STRING,
  "age" STRING,
  "education" STRING,
  "Gender" STRING);
  
  
 
 SELECT * FROM LOAN_PAYMENT;

 
 -- Load data from a CSV file in an S3 bucket into the LOAN_PAYMENT table
-- This command uses Snowflake's metadata tracking to avoid loading the same file multiple times
-- On first run: the file is read, parsed, and 500 rows are loaded into the table
-- On next runs: the same file is skipped automatically to prevent duplicate inserts

-- To reload the same file again (forcefully), add: FORCE = TRUE

 //Loading the data from S3 bucket  
 COPY INTO LOAN_PAYMENT
    FROM s3://bucketsnowflakes3/Loan_payments_data.csv
    file_format = (type = csv 
                   field_delimiter = ',' 
                   skip_header=1);
    

//Validate
 SELECT * FROM LOAN_PAYMENT;