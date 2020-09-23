#! /usr/bin/perl
use strict;
use warnings;

#####################################
#arrange files used for graphical presentation
# usage:perl normal.pl Xref-50000.windowed.pi Xalt-50000.windowed.pi  X-50000.pi
#######################################
my $dir="/rd/mahj/transposon/plot/ssk/redoSS";
chdir $dir;
open INREF,"$ARGV[0]";
open INALT,"$ARGV[1]";
open OUT,">$ARGV[2]";
my %alt;
my %ref;
while (<INREF>) {
    chomp $_;
    if ($_ !~/CHROM/) {
        my @line=split "\t",$_;
        $ref{$line[1]}=$line[4];
    }
}
while (<INALT>) {
    chomp $_;
    if ($_ !~/CHROM/) {
        my @line=split"\t",$_;
        $alt{$line[1]}=$line[4];
    }
}


my $line1=`head -2  $ARGV[0] |tail -1`;
my $line2=`tail -1 $ARGV[0]`;
my @temp1=split "\t",$line1;
my @temp2=split "\t",$line2;
my $head=$temp1[1];
my $tail=$temp2[1];

print $head."\n";
print $tail."\n";
my $num=$head;
while ($num<=$tail) {
    if (exists($ref{$num})) {
        print OUT $num."\t".$ref{$num}."\tA\n";
    }else {
        print OUT $num."\t0\tA\n";
    }
    if (exists($alt{$num})) {
        print OUT $num."\t".$alt{$num}."\tP\n";
    }else {
        print OUT $num."\t0\tP\n";
    }
    $num=$num+1000;
}
