#!/usr/bin/perl -w
#use Parallel::ForkManager;
use Data::Dumper;

print "Input directory name:\n";
chomp($parent=<>);

# For GSNAP output files 
# read in only *_unsortfix.bam files
my @files = <$parent/*_unsortfix.bam>;

my $cmd;

# traverse through each unsortfix.bam file
foreach (@files)
{
		$cmd="samtools view -f 0x0002 $_ | cut -f1 | uniq | wc -l";
		print $cmd,"\n";
		system($cmd);
}

# using the total reads, get a percentage of uniquely mapped reads
