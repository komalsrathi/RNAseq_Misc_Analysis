#!/usr/bin/perl
use File::Basename;
use Spreadsheet::XLSX;

# xls file has two columns, old name and new name
my $xlsxfile='/home/krathi/scripts/Samples_20130814.xlsx';
# source where files lie
my $source='/home/krathi/scripts/fastq';
my @temp;

#open the directory containing fastq files, read the names of the files, close the directory
opendir(DIR, $source) or die "Can't open the current directory: $!\n";

#read in only .fastq.gz files
my @files = <$source/*.fastq.gz>;

closedir(DH);

my $excel = Spreadsheet::XLSX -> new ($xlsxfile, $converter); 
foreach my $sheet (@{$excel -> {Worksheet}}) 
{
        $sheet -> {MaxRow} ||= $sheet -> {MinRow};
        foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) 
        {
                $sheet -> {MaxCol} ||= $sheet -> {MinCol};
                foreach my $col ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) 
                {                
                        my $cell = $sheet -> {Cells} [$row] [$col];
                        if ($cell) 
                        {
                                push(@temp,$cell->value());
                        } 
                }
        }
}

foreach $files(@files)
{
        print "\nFile: $files";
        my $basename=basename($files);
        
        $files=~/(\d+\-\d+).*(\_R\d)/;
        print "\n$1 and $2";
        
        my( $index )= grep { $temp[$_] eq $1 } 0..$#temp;
        print "\nIndex: $temp[$index] Value: $temp[$index-1]";
        print "\nOldname: $basename Newname: $temp[$index-1]$2.fastq.gz\n";
        
        #system("mv $files $source/$temp[$index-1]$2.fastq.gz");
}
