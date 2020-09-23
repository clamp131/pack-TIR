#!/usr/bin/perl -w
use strict;

open FILE,"pack_TIR_human_list";
chomp (my @a=<FILE>);
close FILE;
chdir "..";
LINE:for (my $i=0;$i<=$#a;$i++){
    my @line=split/\t/,$a[$i];
    my $fas=$line[1].".fa"; #human genome file
    chdir "$line[1]"; #go to the folder contaning human genome file
    open FILE1,"$fas";
    my $name='';
    my %all=();
    while(<FILE1>){
	chomp $_;
	if($_=~/^>/){
	    $name=substr($_,1,);
	}else{
	    $all{$name}.=$_;
	}
    }
    close FILE1;
    
    my @line1=split/[:-]/,$line[2];
    my @line2=split/[:-]/,$line[3];
    chdir "..";
    #print "$line1[0]\n$line1[1]\n$line1[2]\n";
    chdir "simulation";
    my $len=$line1[2]-$line1[1]+1;
    my $fas1=substr($all{$line1[0]},$line1[1]-1-$len/2,$len*2); #parental copy and flanking region 
    $fas1=~tr/atcg/ATCG/;
    #my $fas2=substr($all{$line2[0]},$line2[1]-100,$line2[2]-$line2[1]+200);
    #if($line[4] eq '-'){
    #	$fas1=~tr/ATCGatcg/TAGCtagc/;
    #	$fas1=reverse $fas1;
    #}
    
    open OUT,">$line[0].fas";
    print OUT ">$line[2],p\n$fas1\n";
    close OUT;
    chdir "..";
}