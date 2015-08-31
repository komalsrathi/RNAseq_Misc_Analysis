#!/bin/bash
# this program works on .SAM files
# source dir where you sam files are
sourcedir=<>

for f in $sourcedir/*.sam
do      
                fbase=$(basename "$f")
                echo "File: $f Name: $fbase"
                # extract header
                sed 1,27d $f > file_noHeader.sam
                head -n 27 $f > head
                # extract random number of reads
                awk 'BEGIN {srand()} {printf "%05.0f %s \n",rand()*9999999, $0; }' $f | sort -n | head -2000| sed 's/^[0-9]* //' > randomReads.tmp
                cat head randomReads.tmp > ${f%%.*}_randomReads.sam
                rm  head file_noHeader.sam randomReads.tmp     
                # extract TLENs
                # awk 'NR>27 {print $9}' ${f%%.*}_randomReads.sam > ${f%%.*}_tlen.txt
        
done
