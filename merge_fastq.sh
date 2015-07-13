#!/bin/bash
#script to loop through directories to merge fastq files
sourcedir=<>
destdir=<>

for f in $sourcedir/*
do
	count=`ls -1 $f/*.fastq.gz 2>/dev/null | wc -l`
	if [ $count != 0 ]
	then
       		fbase=$(basename "$f")
       		echo "Inside $fbase"
       		zcat $f/*R1*.fastq.gz | gzip > $destdir/"$fbase"_R1.fastq.gz &
       		zcat $f/*R2*.fastq.gz | gzip > $destdir/"$fbase"_R2.fastq.gz &
	fi
done
wait
