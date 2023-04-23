CREATE OR REPLACE PROCEDURE deploy_ddls_from_file(file_path VARCHAR)
RETURNS VARCHAR
LANGUAGE PYTHON
AS
$$
import snowflake.connector
import os

# set up connection parameters
account = '<account>'
user = '<user>'
password = '<password>'
database = '<database>'
schema = '<schema>'

# set up log file
log_file = open('deploy_ddls.log', 'w')

# read the file containing the DDL paths
with open(file_path, 'r') as file:
    ddl_paths = [line.strip() for line in file.readlines()]

# connect to Snowflake
conn = snowflake.connector.connect(
    user=user,
    password=password,
    account=account,
    database=database,
    schema=schema
)

cur = conn.cursor()

# loop through the DDL paths and deploy each statement
for ddl_path in ddl_paths:
    if ddl_path and os.path.isfile(ddl_path):
        # read the DDL statements from the file
        with open(ddl_path, 'r') as f:
            ddl_statements = f.read().split(';')

        for ddl_statement in ddl_statements:
            if ddl_statement.strip():
                try:
                    # execute the DDL statement
                    cur.execute(ddl_statement)
                except snowflake.connector.errors.DatabaseError as e:
                    # log any errors to the log file
                    log_file.write(f"Error deploying DDL {ddl_path}: {e}\n")
                    log_file.flush()

# close the log file and Snowflake connection
log_file.close()
cur.close()
conn.close()

return 'Done'
$$;
