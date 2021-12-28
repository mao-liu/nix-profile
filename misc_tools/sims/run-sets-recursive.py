#! /usr/bin/env python
'''
run-sets-recursive.py PATH
e.g. 
run-sets-recursive.py .

Recursively run all run-sets.sh which are found in subdirectories of PATH.
Does not look in the ./dielectric/, ./rg/ or ./resources/ directories.
'''
import glob, os, sys, fnmatch


thisscript="run-sets-recursive.py" #Define this script.

def boldstring(l):
	'''A quick routine to bold a string for output'''
	bolded="\033[1m"+l+"\033[0;0m";
	return bolded
def printerror():
	print "Error: " + str(sys.exc_info()[1]) # Print the error for debugging
	print "To check the documentation, use: "+boldstring(thisscript+" -h") # Give syntax for help
	sys.exit(0)
	
try:
	# See if the user is seeking help
	# If no inputs are given, this throws an Index exception.
	# and the 'except' output will be printed.
	if sys.argv[1]=="-h" or sys.argv[1]=="--help":
		print __doc__ # print the __doc__ string at the beginning of the file
		os._exit(0) # use os._exit(0) to exit without throwing an exception
		
	folder=sys.argv[1]
except:
	printerror()
os.chdir(folder)
origdir=os.getcwd()+'/'

sets=os.walk('.').next()[1]

for i in range(len(sets))[::-1]:
	if sets[i]=="dielectric" or sets[i]=="rg" or sets[i]=="resources":
		del sets[i]
nsets=len(sets)

n=0
for i in range(nsets):
	for root, dirnames, filenames in os.walk('./'+sets[i]):
		for runscript in fnmatch.filter(filenames, 'run-sets.sh'):
			os.chdir(root)
			os.system("pwd")
			os.system("./run-sets.sh")
			n=n+1
			os.chdir(origdir)
			

print "Submitted "+str(n)+" run-sets.sh files."
