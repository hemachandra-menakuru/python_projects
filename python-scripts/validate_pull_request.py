import sys
import os

GITHUB_HEAD_REF = (os.environ.get('GITHUB_HEAD_REF'))
GITHUB_BASE_REF = (os.environ.get('GITHUB_BASE_REF'))

print('GITHUB_BASE_REF:',GITHUB_HEAD_REF)
print('GITHUB_BASE_REF:',GITHUB_BASE_REF)

base_branch = "main"
source_branch = "release_v.1.0/domain_release"

branch_first_string=source_branch.split('/')[0]
print(branch_first_string)

validate_branch = bool('release' in branch_first_string)
print(validate_branch)

if not validate_branch:
    #print('Not a valid branch to merge into main branch')
    sys.exit("Not a valid branch to merge into main branch") 
