#! /usr/bin/env python

# Extract data from one or many toy md calculations.

import sys
import os
#import subprocess
import glob

# def openlog():
# 	logfile = glob.glob("md.log")
# 	if len(logfile) == 0:
# 	else:
# def log(message):
# def closelog(handle):
# Have we a single run or many?
#RunDirs = glob.glob("run*")

# Find all the output files. 
# For the moment, only process
# the first output file.
OutputFiles = glob.glob("*.output")
TargetLabels = sys.argv[1:]
OutputFile = OutputFiles[0]

# Make sure each label is three characters.
PaddedLabels = []
for label in TargetLabels:
	if len(label)==3:
		PaddedLabels.append(label)
	else:
		if len(label)==2:
			PaddedLabels.append(label+" ")
		else:
			if len(label)==1:
				PaddedLabels.append(label+"  ")
			else: 
				print("select.py error: label is the wrong length")

# Now open the files.
inhandle = open(OutputFile,"r")
outhandles = []	
for label in TargetLabels:
	outhandles.append(open(OutputFile[:-7]+"."+label,"w"))
		
# Construct a dictionary that we'll use to direct each line to an output
# file based on the first three characters.
directoutput = dict([(PaddedLabels[m],outhandles[m]) for m in range(len(PaddedLabels))])

# Run through the output lines.
line = inhandle.readline()
while len(line)>0:
	if line[:3] in directoutput:
		directoutput[line[:3]].write(line)
	line = inhandle.readline()

#for (handle,label)
#outhandle = open(OutputFile[-7:]+
# This is the call to grep used in the old version.
#for Target in TargetLabels:
#	os.system("grep '"+Target+"  ' "+OutputFile+" > "+OutputFile[:-7]+"."+Target)

