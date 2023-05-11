import sys

print ('hello world')

val1=5

def fun_test(val1):
    for i in range (val1):
        x=i*val1
        print(x)
    return x
    
fun_test(val1)

SELECT
  '<?xml version="1.0" encoding="UTF-8"?>' || 
  '<employees>' || 
  LISTAGG(
    '<employee>' ||
    '<ID>' || ID || '</ID>' ||
    '<FirstName>' || FirstName || '</FirstName>' ||
    '<LastName>' || LastName || '</LastName>' ||
    '<Department>' || Department || '</Department>' ||
    '</employee>',
    '') WITHIN GROUP (ORDER BY ID) ||
  '</employees>' AS xml_data
FROM
  employees;
