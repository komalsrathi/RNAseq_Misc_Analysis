#!/usr/bin/perl -w
use Parallel::ForkManager;
use Data::Dumper;

my $parent='in';
my $destdir='out';

# open parent directory
opendir(DIR, $parent) or die "Can't open the current directory: $!\n";

# read sub-directory names into @dirs 
my @dirs = grep {-d "$parent/$_" && ! /^\.{1,2}$/} readdir(DIR);

# run parallel jobs
my $pm=new Parallel::ForkManager(30);

# traverse through each subdirectory of the parent directory
foreach (@dirs)
{
        $pm -> start and next;
        # execute this block only if directory contains .fastq.gz files
        my @txt = <$parent/$_/*.fastq.gz>;
        if(@txt)
        {               
                print "Inside $_ \n";
                system("zcat $parent/$_/*R1*.fastq.gz | gzip > $destdir/$_.R1.fastq.gz");
                system("zcat $parent/$_/*R2*.fastq.gz | gzip > $destdir/$_.R2.fastq.gz");
        }
        $pm -> finish;
}
