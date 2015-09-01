use Parallel::ForkManager;
use Data::Dumper;

# import a csv file of samples
my $fastqfile = "samples_fastq.csv";
open FILE, $fastqfile or die;

# split file by comma
while(<FILE>){
        chomp;
        my @r = split(',');
        push(@samples,\@r);
}

# assign 8 cores
my $pm=new Parallel::ForkManager(8);

# to make the GFF file use
# dexseq_prepare_annotation.py Homo_sapiens.GRCh37.75.gtf Homo_sapiens.GRCh37.75.DEXSeq.gff
foreach (@samples)
{       
    $pm->start and next;     
          # use sam file as input
          my $dexseq_count="python dexseq_count.py -p yes Homo_sapiens.GRCh37.75.DEXSeq.gff input/".$_->[2]."_filter_sort.sam output/".$_->[2]."_filter_sort.txt";
          print $dexseq_count,"\n"; 
          system($dexseq_count);
    $pm->finish;
}
