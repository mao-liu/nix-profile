#!/bin/bash

if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
  echo "$0 [-b BLOCK] < INPUT"
  echo "Calculates simple statistics (mean, std.dev, std.err) for a single column of data."
  echo ""
  echo "Optional -b flag allows the input of a BLOCK size, defined by"
  echo "     std.err = std.dev/(BLOCK)^0.5"
  echo "This is the block averaging method as per Allen & Tildesley"
  exit 0
fi

if [[ $1 == "-b" ]]; then
  b=$2
else
  b=1
fi
awk -v b=${b} '{sum+=$1;sum2+=$1*$1;n+=1}
                END { mean=sum/n;mean2=sum2/n;
                var=mean2-mean*mean;
                sd=sqrt(var);se=sd/sqrt(n/b);
                printf("%d\t%.10e\t%.10e\t%.10e\n",
                        n,mean,sd,se);}';
