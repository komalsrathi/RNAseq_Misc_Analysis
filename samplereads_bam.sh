#!/bin/bash
# this script works on .BAM files

# for BAM files using picard or samtools
# samtools: samtools view -s 0.5 -b file.bam > random_half_of_file.sam

# picard either keeps or discards both mate pairs
# picard: java -Xmx2g -jar DownsampleSam.jar PROBABILITY=1 INPUT=input.bam OUTPUT=output_shuffle.sam

sourcedir=<>

for f in $sourcedir/*.bam
do      
		fbase=$(basename "$f")
		describer=$(echo ${f} | sed 's/.bam//')
		#extract random number of reads
		samtools view -s 0.5 -b $f > ${describer}_randomReads.sam     
		#extract TLENs
		awk 'NR>27 {print $9}' ${describer}_randomReads.sam > ${describer}_tlen.txt
		#remove the intermediate file
		rm ${describer}_randomReads.sam
done


