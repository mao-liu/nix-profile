#!/bin/bash --login
###########################################################
# A bash script to run a number of sets of HPC jobs.      #
# Uses qsub, for systems using the PBS queueing system.   #
#                      By Maoyuan Liu (myliu), 17/02/2012 #
###########################################################

###########################################################
# Setting up parameters                                   #
###########################################################

# Each set is job1runs + job2runs
setstarget=2

# Number of job1, and the location of its PBS script.
job1runs=3
job1="polylj.0000lj1.0.merri.runscript"

# Number of job2, and the location of its PBS script.
job2runs=0
job2="-"

# Email address to send a notification upon completion.
emailaddr="run-sets@mao.id.au"

###########################################################
# Initializing the script                                 #
###########################################################

# work out how many jobs to submit per set
jobstarget=`expr $job1runs + $job2runs`

# read in the current set
if [ ! -f currentset.run-sets ]; then
	echo 1 > currentset.run-sets
fi
sets=$(cat currentset.run-sets)

# read in the current job count
if [ ! -f currentjob.run-sets ]; then
	echo 0 > currentjob.run-sets
fi
jobs=$(cat currentjob.run-sets)

###########################################################
# Some outputs related to the previous job                #
###########################################################

#####
# is this the first job?
if [ $sets -eq 1 ] && [ $jobs -eq 0 ]; then
	echo "###########################################################" >> run-sets.log
	echo "# A new instance of run-sets is starting.                 #" >> run-sets.log
	echo "###########################################################" >> run-sets.log
	echo "" >> run-sets.log
	echo "Hello, I am run-sets." >> run-sets.log
	echo "The time is $(date)." >> run-sets.log
	echo "I will be executing jobs as $(whoami)@$(hostname)" >> run-sets.log
	echo "I will be executing $setstarget sets of $jobstarget jobs," >> run-sets.log
	echo "	each set will start with $job1runs runs of $job1," >> run-sets.log
	echo "	followed by $job2runs runs of $job2." >> run-sets.log
	echo "I will send an email to $emailaddr when I am finished." >> run-sets.log
	echo "Sit back and enjoy!" >> run-sets.log
	echo "" >> run-sets.log
	
# otherwise, a job has just finished. Print some outputs!
else
	echo "##### Job finished at $(date)." >> run-sets.log
fi

#####
# is this the last job of a set?
if [ $jobs -eq $jobstarget ]; then
	echo "##### --" >> run-sets.log
	echo "# Set $sets has finished at $(date)." >> run-sets.log
	jobs=1
	sets=`expr $sets + 1`
	
# otherwise, iterate the job count
else
	jobs=`expr $jobs + 1`
fi

#####
# Have we finished all the jobs?
if [ $sets -gt $setstarget ]; then
	echo "################" >> run-sets.log
	echo "All sets are finished." >> run-sets.log
	rm currentset.run-sets
	rm currentjob.run-sets
	
	# send an email to notify
	currentdir=$(pwd | rev | cut -d "/" -f1 | rev)
	mailsubject="run-sets.Finished:[${currentdir}]-on-$(hostname)"
	echo "Jobs at $(whoami)@$(hostname):$(pwd) have finished." > mail.txt
	echo "" >> mail.txt
	echo "This message has been automatically generated." >> mail.txt
	mail -s $mailsubject $emailaddr < mail.txt
	rm mail.txt
	
	echo "Email notification sent." >> run-sets.log
	echo "The time is $(date)." >> run-sets.log
	echo "Goodbye." >> run-sets.log
	echo "" >> run-sets.log
	
	# quit
	exit 0

# or, is this the first job of a new set?
elif [ $jobs -eq 1 ]; then 
	echo "################" >> run-sets.log
	echo "# Set $sets started at $(date)." >> run-sets.log
fi

# save the current job number and set number
echo $jobs > currentjob.run-sets
echo $sets > currentset.run-sets

###########################################################
# Submit the job                                          #
###########################################################

# print out some info.
echo "##### --" >> run-sets.log
echo "##### Job ${jobs}" >> run-sets.log
echo "##### The time is $(date)." >> run-sets.log

if [ $jobs -le $job1runs ]; then
	echo "##### Running ${job1}." >> run-sets.log
	qsub $job1 >> run-sets.log 2>&1
else
	echo "##### Running ${job2}." >> run-sets.log
	qsub $job2 >> run-sets.log 2>&1
fi

###########################################################
# Waiting for the job to finish. Once it's finished, the  #
# PBS script will call this script.                       #
###########################################################