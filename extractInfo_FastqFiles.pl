#!/usr/bin/perl
use File::Basename;

my @arr;
my $joinarr;
my $count=0;

#directory containing fastq files
my $parent='/Users/komalr/Desktop/komalrclust/ngs/MAGnet_LV_QC/Fastq';

#open the directory containing fastq files, read the names of the files, close the directory
opendir(DIR, $parent) or die "Can't open the current directory: $!\n";

#read in only .fastq.gz files
my @files = <$parent/*.fastq.gz>;
closedir(DH);

#open a CSV file in write mode
open (FH, ">file.csv") or die "$!";

#print the header for the csv file
print FH "ngs_assay_id, ngs_library_id, seqname, platform, readtype, readlength, machinename, flowcell, lane\n";

#traverse through all the files ending with .fastq extension in parent folder
foreach my $file(@files) 
{
        #extract the file name
        (my $filename = basename($file)) =~ s/.fastq.gz//;
        print "Reading $filename";
        print "\n";

        #open .fastq.gz file 
        open MYFILE, "gunzip -c $file|" or die $!;
        
        #read only first line
        my $firstline=<MYFILE>; 
        
        #split the first line into array
        @arr=split /[:\s]/,$firstline;
        
        #increment counter
        $count++;
        
        #print data to csv file
        print FH "$count,NULL,$filename,Illumina 1.9,Stranded PE,99,$arr[0],$arr[2],$arr[3]\n";
        
        #close file
        close (MYFILE);         
        }

#close the header to csv file
close(FH);
