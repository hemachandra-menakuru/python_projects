import sys

print ('hello world')

val1=5

def fun_test(val1):
    for i in range (val1):
        x=i*val1
        print(x)
    return x
    
fun_test(val1)


--------

Hi Doug, I have observed something interesting, and in fact, dangerous, while discussing with Richelle. There is an ETL role called ETL_DATA_ROLE, which is specifically designed for service accounts. Informatica and Airflow service accounts use this role to transform data, and it has permissions to INSERT/UPDATE/DELETE/TRUNCATE data. However, user accounts are now using this role through AD Roles. This means that anyone who has access to this role can perform all operations through the Snowflake UI. While no one may intentionally cause harm, the chances of accidental actions are very high. This can lead to data irregularities and make it difficult to analyze failures. We may need to raise this issue with BDH and discuss the removal of the AD role from the domain. We should also consider alternative roles for granting users.
