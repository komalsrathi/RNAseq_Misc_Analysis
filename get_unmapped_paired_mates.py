#!/usr/bin/env python
import csv
import sys

if(len(sys.argv) != 2) :
    print("Usage: samtools view -f 0x4 foo.bam | %s prefix\n" % sys.argv[0])
    sys.exit(1)

f = csv.reader(sys.stdin, dialect="excel-tab")
prefix = sys.argv[1]
paired1 = open("%s_1.fastq" % prefix, "w")
paired2 = open("%s_2.fastq" % prefix, "w")
unpaired = open("%s.unpaired.fastq" % prefix, "w")
last = None
for line in f :
    if(last == None) :
        last = [line[0], line[9], line[10]]
    else :
        if(last[0] == line[0]) :
            paired1.write("%s\n%s\n+\n%s\n" % (last[0], last[1], last[2]))
            paired2.write("%s\n%s\n+\n%s\n" % (line[0], line[9], line[10]))
            last = None
        else :
            unpaired.write("%s\n%s\n+\n%s\n" % (last[0], last[1], last[2]))
            last = [line[0], line[9], line[10]]
if(last != None) :
    unpaired.write("%s\n%s\n+\n%s\n" % (last[0], last[1], last[2]))

paired1.close()
paired2.close()
unpaired.close()
