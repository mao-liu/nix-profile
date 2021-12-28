#!/bin/bash

if [ $1 == "-h" ]; then
  echo "SYNTAX: dumbplot.sh FUNCTION VAR START END"
else
  echo "If you derp'd, you will get error. Check -h for syntax."
fi

math 1>/dev/null 2>/dev/null << END
tempplot=Plot[$1,{$2,$3,$4}];
Export["tempplot.dat",tempplot,"TEXT"];
END

cat tempplot.dat | sed -e 's/.*Line\[\(.*\)\]\}\}\}.*/\1/g' | sed -e 's/{\(.*\)}/\1\n/g' | sed -e 's/}, {/\n/g' | sed -e 's/, /\t/g' -e 's/}//g' -e 's/{//g' | head -n -1 > tempplot.coords

gnuplot << END
set term dumb
set nokey
plot 'tempplot.coords'
END

rm tempplot.dat tempplot.coords
