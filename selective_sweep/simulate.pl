#! /usr/bin/perl
use strict;
use warnings;

################
# random get 1000 sites from X synonymous site and recombination site and keep the re#fnum=altnum the output file is sum_X_1000 ; chr pos refpi altpi
# perl script3.pl 10000
#################
#open OUT,">sum_X";
open OUT, ">sum_X_1000";
my ($window)=@ARGV;
open IN0,"vcf_strains";
my @strain;
foreach (<IN0>) {
    chomp $_;
    @strain=split/\t/,$_;
}

my @newline=&rand_num(1000,5780);

#open IN1, "test1";
open IN1, "dgrp_freqSNP_X.tab";
my $num=1;
my $n=1;
foreach (<IN1>) {
    chomp $_;
    if(grep { $_ eq $n } @newline){
    my @elements=split/\t/,$_;
    my @refstrain;
    my @altstrain;
    my $chr=$elements[1];
    my $pos=$elements[2];
    my $start=$pos-$window;
#    my $end=$pos+$window;
    my $end=$pos;
    my $outref="refpi_".$num."_".$window;
    my $outalt="altpi_".$num."_".$window;
    open OUT1, ">refstrain_tmp";
    open OUT2,">altstrain_tmp";
    for (my $i=19;$i<=$#elements;$i++) {
        if ($elements[$i] eq "0/0") {
#            push @refnum, $i;
 #           print OUT1 $strain[$i-19]."\n";
            push @refstrain, $strain[$i-19];
        }elsif ($elements[$i] eq "1/1") {
 #           push @altnum, $i;
            print  OUT2 $strain[$i-19]."\n";
            push @altstrain, $strain[$i-19];
        }
    }
    my $numalt=$#altstrain+1;
    my $numref=$#refstrain+1;
    print $numalt."\t".$numref."\n";
    my @newnum=&rand_num($numalt,$numref);
    print "@newnum\n";
    foreach (@newnum) {
        print OUT1 $refstrain[$_-1]."\n";
    }

    system( "vcftools --vcf dgrp2.vcf --keep refstrain_tmp --chr $chr  --from-bp $start --to-bp $end --remove-indels --window-pi 1000 --window-pi-step 500 --out $outref");
    system( "vcftools --vcf dgrp2.vcf --keep altstrain_tmp --chr $chr  --from-bp $start --to-bp $end --remove-indels --window-pi 1000 --window-pi-step 500 --out $outalt");
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
    print OUT "$chr\t$pos\t$refmedian\t$altmedian\n";
    close OUT1;
    close OUT2;
    $num++;
    system("rm -rf ${outref}.*");
    system("rm -rf ${outalt}.*");
}
    $n++;
}







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


sub rand_num {
    #$n is the count that is random print
    #$m is the overall count that is chosen from
   my ($n,$m) = @_;
   my %h; my @h;
   while (@h < $n) {
       my $r = int rand($m);
       $r=int($r)+1;
       push @h, $r if (!exists $h{$r});
       $h{$r} = 1;
   }
   return @h;
}
