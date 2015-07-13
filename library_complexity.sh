#!/bin/bash

$source=<>
$dest=<>

files=('sample1' 'sample2' 'sampleN')

for i in ${!files[*]}
do
	printf "   %s\n" "${files[$i]}\n"
	java -jar /opt/picard/EstimateLibraryComplexity.jar \
	INPUT=$source/${files[$i]}"."bam \
	OUTPUT=$dest/${files[$i]}"_libcomp.txt" \
	VALIDATION_STRINGENCY=SILENT \
	VERBOSITY=ERROR
done
