#!/bin/bash --login

echo "###########################################################" >> run-sets.log
echo "# Run-sets suspended."

rsync -a . myliu@bruce.vlsci.unimelb.edu.au:$( pwd )/
ssh myliu@bruce.vlsci.unimelb.edu.au "cd $( pwd ); mv run-sets.sh.save run-sets.sh; ./run-sets.sh"
