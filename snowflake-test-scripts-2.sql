-- Set the parameters
SET username = 'myusername';
SET password = 'mypassword';
SET database = 'mydatabase';
SET schema = 'myschema';
SET file_path = '/path/to/ddls.txt';

-- Read the file containing the DDL paths
SELECT $file_path;

-- Set up the connection
CREATE OR REPLACE CONNECTION snowflake_conn
  USER='${username}'
  PASSWORD='${password}'
  ACCOUNT='myaccount'
  DATABASE='${database}'
  SCHEMA='${schema}';

-- Set the log file
CREATE OR REPLACE STAGE deploy_ddls_stage
  URL='s3://mybucket/deploy_ddls_stage/'
  CREDENTIALS=(AWS_KEY_ID='<AWS access key ID>',
               AWS_SECRET_KEY='<AWS secret access key>');

-- Copy the DDL files to the stage
PUT file://${file_path} @deploy_ddls_stage;

-- Loop through the DDL files and deploy each statement
SET ddl_files = (SELECT LISTAGG(@deploy_ddls_stage||$1, ',') FROM
                (SELECT DISTINCT VALUE FROM TABLE(SPLIT_TO_TABLE($file_path, '\n'))) AS files);

SELECT $ddl_files;

CREATE OR REPLACE TABLE deploy_ddls_errors (error_text STRING);

CREATE OR REPLACE TASK deploy_ddls
  WAREHOUSE=mywarehouse
  WHENEVER SQLERROR CONTINUE
AS
  DECLARE
    ddl_stmt STRING;
  BEGIN
    FOR ddl_file IN (SELECT VALUE FROM TABLE(SPLIT($ddl_files, ',')))
    DO
      FOR ddl_stmt IN (SELECT VALUE FROM TABLE(SPLIT_TO_TABLE('SELECT $1 FROM @deploy_ddls_stage/' || ddl_file, ';')))
      DO
        IF ddl_stmt != '' THEN
          BEGIN
            EXECUTE IMMEDIATE ddl_stmt;
          EXCEPTION WHEN OTHERS THEN
            INSERT INTO deploy_ddls_errors VALUES ($$Error deploying DDL statement: $$ || ddl_stmt || $$ - Error message: $$ || ERROR_MESSAGE());
          END;
        END IF;
      END FOR;
    END FOR;
  END;
;

-- Run the task
CALL deploy_ddls();

-- Get the errors, if any
SELECT * FROM deploy_ddls_errors;
