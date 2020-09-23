#! /usr/bin/perl 
use strict;
use warnings;
##########usage#####################
#calculate PI in a window
#perl calinsertpi.pl  3R1_ind_70_exclude  3R1_ind_70  3R  13449520 2500 insert3R1pi.tab
#################################
my $dir="/rd/mahj/transposon/plot/ssk/redoSS";
chdir $dir;
my ($fileref, $filealt, $chr, $pos, $window, $outfile)=@ARGV;
my $outref=$chr."ref-".$window;
my $outalt=$chr."alt-".$window;
open IN1, $fileref;
open IN2, $filealt;
open OUT,">$outfile";

my $start=$pos-$window;
my $end=$pos+$window;
system( "vcftools --vcf dgrp2.vcf --keep $fileref --chr $chr  --from-bp $start --to-bp $end --remove-indels --window-pi 1000 --window-pi-step 500 --out $outref");
system( "vcftools --vcf dgrp2.vcf --keep $filealt --chr $chr  --from-bp $start --to-bp $end --remove-indels --window-pi 1000 --window-pi-step 500 --out $outalt");
open REF, "${outref}.windowed.pi";
my @valueref;
while (<REF>) {
    chomp $_;
    my @line=split"\t",$_;
    if ($_ !~ /^CHROM/) {
        push @valueref, $line[4];
    }
}
my $refmedian=&mid(@valueref);

open ALT, "${outalt}.windowed.pi";
my @valuealt;
while (<ALT>) {
    chomp $_;
    my @line=split"\t", $_;
    if ($_ !~/^CHROM/) {
        push @valuealt, $line[4];
    }
}
my $altmedian=&mid(@valuealt);

print OUT  "$chr\t$pos\t$refmedian\t$altmedian\n";
print  "$chr\t$pos\t$refmedian\t$altmedian\n";


close IN1;
close IN2;
close OUT;
close REF;
close ALT;




##median function
sub mid{
    my @list = sort{$a<=>$b} @_;
    my $count = @list;
    if( $count == 0 )
    {
        return undef;
    }
    if(($count%2)==1){
        return $list[int(($count-1)/2)];
    }
    elsif(($count%2)==0){
        return ($list[int(($count-1)/2)]+$list[int(($count)/2)])/2;
    }
}
