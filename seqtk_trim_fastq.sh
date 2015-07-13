#!/bin/bash

# set sourcedir to directory - originial fastq files
sourcedir=<>
# set destdir to directory - trimmed fastq files
destdir=<>

# change extension of your fastq accordingly
for f in $sourcedir/*.fastq.gz
do      
	fbase=$(basename "$f")
	echo "${fbase%.fastq.gz}"
	echo "zcat $sourcedir/$fbase | seqtk trimfq -e 25 - | gzip - > $destdir/${fbase%.fastq.gz}_trim.fastq.gz"
	zcat $sourcedir/$fbase | seqtk trimfq -e 25 - | gzip - > $destdir/${fbase%.fastq.gz}_trim.fastq.gz &
done

# for txt.bz2 files
for f in $sourcedir/*.txt.bz2
do      
        fbase=$(basename "$f")
        echo "${fbase%.txt.bz2}"
        echo "bzcat $sourcedir/$fbase | seqtk trimfq -e 25 - | bzip2 - > $destdir/${fbase%.txt.bz2}_trim.txt.bz2"
        bzcat $sourcedir/$fbase | seqtk trimfq -e 25 - | bzip2 - > $destdir/${fbase%.txt.bz2}_trim.txt.bz2 &
done
