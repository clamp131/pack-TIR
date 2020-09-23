#!/usr/bin/perl -w
use strict;


for(my $tsj=1;$tsj<=33;$tsj++){
open FILE,"$tsj.fas"; ##pack-TIR and parental copy sequences
chomp (my @a=<FILE>);
close FILE;

open OUT,">$tsj.out";
my $len=(length($a[1]))/2;
my $num=0;

LINE:while(1){
    my $fas='';
    srand;
    my $start_fas=int(rand(length($a[1])-1));
    if($start_fas+$len<=length($a[1])){
	my $fas=substr($a[1],$start_fas,$len);
	$num++;
	
	srand;
	my $start_te=int(rand(length($a[3])-1-20))+10;
	my $end_te=int(rand(length($a[3])-1-20))+10;
	my $te1=substr($a[3],0,$start_te);
	my $te2=substr($a[3],$end_te);
	
	################################################
	my $homo1='';
	my $homo2='';
	my $start=0;
	my $end=0;
	LINE1:for(my $m=length($fas);$m>0;$m--){
	    my $base1=substr($fas,0,$m);
	    my $base2=substr($te1,-$m,);
	    $base2=~tr/atcg/ATCG/;
	    if($base1 eq $base2){
		$homo1=$base1;
		$start=$m;
		last LINE1;
	    }
	}
	
	LINE2:for(my $m=length($fas);$m>0;$m--){
	    my $base1=substr($fas,-$m,);
	    my $base2=substr($te2,0,$m);
	    $base2=~tr/atcg/ATCG/;
	    if($base1 eq $base2){
		$homo2=$base1;
		$end=$m;
		last LINE2;
	    }
	}
	print OUT "$start\t$end\n";
	if($num ==100){
	    last LINE;
	}
    }
}
close OUT;
}