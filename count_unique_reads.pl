#!/usr/bin/perl -w
#use Parallel::ForkManager;
use Data::Dumper;

print "Input directory name:\n";
chomp($parent=<>);

# For GSNAP output files
# read in only *_filter_sort.bam files
my @files = <$parent/*_filter_sort.bam>;

my $cmd;

# traverse through each filter_sort.bam file
foreach (@files)
{
		$cmd="samtools view $_ | cut -f 1 | awk '!seen[\$0]++' | wc -l";
		print $cmd,"\n";
		system($cmd);
}
