#!/usr/bin/perl
use File::Basename;

# This script uses Homo_sapiens_75_gtf2bed.bed which is made by using gtf2bed.pl on Homo_sapiens_75 build GTF file from Ensembl

# set source directory
my $source='';
opendir(DIR, $source) or die "Can't open the current directory: $!\n";

# For GSNAP output files
# read in only *_filter_sort.bam files
my @files = <$source/*_filter_sort.bam>;

foreach $files(@files)
{
	#print "\nFile: $files";
	my $basename=basename($files);			
	(my $without_extension = $basename) =~ s/\.[^.]+$//;				
	$without_extension="$without_extension".".out";
	#print "\n";
	my $cmd="bedtools coverage -abam $files -b Homo_sapiens_75_gtf2bed.bed -counts > $without_extension &";					
	print $cmd,"\n";
	system($cmd);
}
