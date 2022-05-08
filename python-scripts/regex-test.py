import re

txt = "The rain in Spain"
x = re.search("^The.*Spain$", txt)


target_branch = "main"
#source_branch= "release_v.1.1/module1"
source_branch= "main"
print(source_branch,target_branch)

val1 = source_branch.split('/')[0]
print(val1)

StringList = [ 'release', 'release_', 'release_v', 'release/' ]
BetterStringList = [ p for p in StringList if (p.startswith(val1))]

print(BetterStringList)

if len(BetterStringList):
	print('The list is not empty')
else:
	print('T list is empty')