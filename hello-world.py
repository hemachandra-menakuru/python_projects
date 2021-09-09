import sys

print ('hello world')

val1=5

def fun_test(val1):
    for i in range (val1):
        x=i*val1
        print(x)
    return x
    
fun_test(val1)