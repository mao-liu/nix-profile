#! /usr/bin/env python
'''
----------------
restarthere.py file
----------------
Recursively restart the output ending in RunNum in the current directory.
Another input file ending in RunNum+1 will be generated.
Runscripts are updated accordingly to fit the new input file name.
Input and output files are moved to .input.back and .output.back when it's done.
----------------
By Mao Yuan Liu, 30/11/2011
chairman@mao.id.au
----------------
USAGE:
restarthere.py str(outputfile)
	outputfile, string, the trailing index of input/output files to restart
----------------
e.g.
restarthere.py spce512.output
	outputfile=spce512.output
----------------
'''

import glob, os, sys, fnmatch, time

start = time.time()
thisscript="restarthere.py" #Define this script.

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
	
	arg1=sys.argv[1]
	
except:
	printerror()

if not(os.path.exists("select.py")):
		print "Error: select.py not found."
		print "Please copy select.py to the current location."
		os._exit(0)

outputfile=glob.glob('*.output')

if len(outputfile)>1:
	print "Error: More than one output files with the suffix .output are found."
	print "	select.py requires only one .output file in the directory."
	os._exit(0)
elif len(outputfile)==0:
	print "Error: No output files are found."
	os._exit(0)
outputfile=outputfile[0]

if outputfile!=arg1:
	print "Error: The output file "+arg1+" does not exist."
	os._exit(0)

runnum=outputfile[-9:-7]
nameprefix=outputfile[:-7]
inputfile=nameprefix+".input"

newindex=str(int(runnum)+1)
if len(newindex)==1:
	newindex='0'+newindex
newnameprefix=nameprefix[:-2]+newindex

runscripts=glob.glob("*.runscript")
for scriptname in runscripts:
	os.system("mv "+scriptname+" "+scriptname+"."+runnum+".back")
	sedcrit1="-e s/"+nameprefix+".input/"+newnameprefix+".input/"
	sedcrit2="-e s/"+nameprefix+".output/"+newnameprefix+".output/"
	os.system("sed "+sedcrit1+" "+sedcrit2+" "+scriptname+"."+runnum+".back"+" > "+scriptname)


# generate some coordinates
os.system('./select.py x v')
os.system('tail -n 1 *.x > endx')

endxHandle=open('endx','r')
endxline = endxHandle.readlines()
endxHandle.close()
endxsplit = endxline[0].split()
NumSites = endxsplit[1]

#Extract the last frame
os.system('tail -n '+str(NumSites)+' '+nameprefix+'.x > lastx')
os.system('tail -n '+str(NumSites)+' '+nameprefix+'.v > lastv')

xhandle = open('lastx','r')
xlines = xhandle.readlines()
xhandle.close()

vhandle = open('lastv','r')
vlines = vhandle.readlines()
vhandle.close()

# Read the input file
InptHandle = open(inputfile,"r")
InptLines = InptHandle.readlines()
InptHandle.close()

# write the output
OutptHandle = open(newnameprefix+'.input','w')
for line in InptLines[:-len(xlines)-len(vlines)]:
	OutptHandle.write(line)
for line in xlines:
	OutptHandle.write(line[12:])
for line in vlines:
	OutptHandle.write(line[12:])

# some cleaning up
os.system('rm '+nameprefix+'.x')
os.system('rm '+nameprefix+'.v')
os.system('rm endx')
os.system('rm lastx lastv')
os.system('mv '+outputfile+' '+outputfile+'.back')
os.system('mv '+inputfile+' '+inputfile+'.back')


'''
		#save a few path and file names
		inputfile=fnmatch.filter(filenames, '*.input')[0]
		processedoutputs.append(os.path.join(root,outputfile))
		nameprefix=inputfile[:-6]
		
		print "Processing "+processedoutputs[-1]
		
		#check if indices need to be advanced
		nameindex=nameprefix[-3:]
		folderindex=root[-3:]
		
		if nameindex[0]=='.' and nameindex[-2:].isdigit():
			newindex=str(int(nameindex[-2:])+1)
			if len(newindex)==1:
				newindex='0'+newindex
			newnameprefix=nameprefix[:-2]+newindex
		else:
			newindex='01'
			newnameprefix=nameprefix+'.'+newindex
			
		newroot=newdir+root[2:]
		
		os.chdir(root) #go to the directory containing the file
		
		# copy auxillary files		
		os.system("cp P.dat "+newroot)
		os.system("cp *.py "+newroot+" 2>/dev/null")
		
		runscripts=glob.glob("*.runscript")
		for scriptname in runscripts:
			sedcrit1="-e s/"+nameprefix+".input/"+newnameprefix+".input/"
			sedcrit2="-e s/"+nameprefix+".output/"+newnameprefix+".output/"
			os.system("sed "+sedcrit1+" "+sedcrit2+" "+scriptname+" > "+newroot+"/"+scriptname)
		
		# generate some coordinates
		os.system(origdir+'select.py x v')
		os.system('tail -n 1 *.x > endx')
		
		endxHandle=open('endx','r')
		endxline = endxHandle.readlines()
		endxHandle.close()
		endxsplit = endxline[0].split()
		NumSites = endxsplit[1]
		
		#Extract the last frame
		os.system('tail -n '+str(NumSites)+' '+nameprefix+'.x > lastx')
		os.system('tail -n '+str(NumSites)+' '+nameprefix+'.v > lastv')
		
		xhandle = open('lastx','r')
		xlines = xhandle.readlines()
		xhandle.close()
		
		vhandle = open('lastv','r')
		vlines = vhandle.readlines()
		vhandle.close()
		
		# Read the input file
		InptHandle = open(inputfile,"r")
		InptLines = InptHandle.readlines()
		InptHandle.close()
		
		# write the output
		OutptHandle = open(newroot+'/'+newnameprefix+'.input','w')
		for line in InptLines[:-len(xlines)-len(vlines)]:
			OutptHandle.write(line)
		for line in xlines:
			OutptHandle.write(line[12:])
		for line in vlines:
			OutptHandle.write(line[12:])
		
		# some cleaning up
		if deletex:
			os.system('rm '+nameprefix+'.x')
		os.system('rm '+nameprefix+'.v')
		os.system('rm endx')
		os.system('rm lastx lastv')
		
		os.chdir(origdir)

os.system('cp *.py '+NewRunDir+' 2>/dev/null')
os.system('cp *.sh '+NewRunDir+' 2>/dev/null')

elapsed = (time.time() - start)
print "Processed "+str(len(processedoutputs))+" files in "+str(int(elapsed))+" seconds"
'''
'''
unused script that can iterate a folder's index (NAME.##)

		if folderindex[0]=='.' and folderindex[-2:].isdigit():
			newfolderindex=str(int(folderindex[-2:])+1)
			if len(newfolderindex)==1:
				newfolderindex='0'+newfolderindex
			newroot=newdir+root[2:-2]+newfolderindex
		else:
			newfolderindex='00'
			newroot=newdir+root[2:]+'.'+newfolderindex
		# update the folder name if necessary
		os.system('mv '+newdir+root[2:]+' '+newroot)
'''