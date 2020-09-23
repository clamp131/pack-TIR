#!/usr/bin/perl -w
use strict;

my $file1=$ARGV[0];
my $file2=substr($ARGV[0],0,index($ARGV[0],'.')).'.4filter';
my $file3=substr($ARGV[0],0,index($ARGV[0],'.')).'.4out';
my $out1=substr($ARGV[0],0,index($ARGV[0],'.')).'.4filter4';

my %count=();
open FILE,"$file1";
while(<FILE>){
    $_=" ".$_;
    my @line=split/\s+/,$_;
    $count{$line[5]}{$line[6]}{end}=$line[7];
    $count{$line[5]}{$line[6]}{name}=$line[10];

}
close FILE;

my %count1=();
open FILE,"$file3";
while(<FILE>){
    my @line=split/\t/,$_;
    my $name=$line[0].",".$line[1].",".$line[2].",".$line[10].",".$line[11].",".$line[12];
    $count1{$name}=$line[4];
    #$count{$line[5]}{$line[6]}{end}=$line[7];
    #$count{$line[5]}{$line[6]}{name}=$line[10];

}
close FILE;

my %all=();
open FILE,"$file2";
while(<FILE>){
    chomp $_;
    my @line=split/\t/,$_;
    my @map1=split/,/,$line[9];
    if($map1[2] eq $line[15] || $map1[4] eq $line[16]){
	$all{$line[9]}{self}{length}=$line[12]-$line[11];
	$all{$line[9]}{self}{length2}=$line[16]-$line[15];

	$all{$line[9]}{self}{hit}=$_;
    }else{
	$all{$line[9]}{other}{$_}{length}=$line[12]-$line[11];
	$all{$line[9]}{other}{$_}{length2}=$line[16]-$line[15];
	$all{$line[9]}{other}{$_}{length3}=$line[7];
	$all{$line[9]}{other}{$_}{chr}=$line[13];
	$all{$line[9]}{other}{$_}{start}=$line[15];
	$all{$line[9]}{other}{$_}{end}=$line[16];
    }
}
close FILE;

open OUT,">$out1";
for my $fas(sort keys %all){
    #my $count=0;
    my %other=();
    my %only=();
    #print "$fas\n";
    my %mulp=();
    for my $hit(sort keys %{$all{$fas}{other}}){
	if($all{$fas}{self}{length}>0 && $all{$fas}{other}{$hit}{length}/$all{$fas}{self}{length}>=0.8 && $all{$fas}{self}{length2}>0 && $all{$fas}{other}{$hit}{length2}/$all{$fas}{self}{length2}>=0.8 && $all{$fas}{other}{$hit}{length2}/$all{$fas}{self}{length2}<=1.2 && $all{$fas}{other}{$hit}{length3}/$all{$fas}{self}{length}<=0.2){
	    #$count++;
	    my $chr=$all{$fas}{other}{$hit}{chr};
	    LINE:for my $start(sort {$a <=> $b} keys %{$count{$chr}}){
	        my $start_1=$start;
	        my $end_1=$count{$chr}{$start}{end};
	        my $start_2=$all{$fas}{other}{$hit}{start};
	        my $end_2=$all{$fas}{other}{$hit}{end};
	        if(($start_1-$end_2 <=100 && $start_1-$end_2 >=-100) || ($start_2-$end_1<=100 && $start_2-$end_1>=-100) ){
	            #$count--;
		    if($count1{$fas} ne $count{$chr}{$start}{name}){
			$other{$hit}++; #orthologuous pack-TIR
		    }else{
			$mulp{$hit}++;
		    }
		    
	        }elsif($start_1-$end_2 >=500){
		    if(!defined $other{$hit} && !defined $mulp{$hit}){
			$only{$hit}++; #parental copy
		    }
		    last LINE;
	        }
	    }
	}
	
	
    }
    #sleep 2;
    if(scalar (keys %only) ==1 && scalar (keys %other)==0){ #can change the parameter
       print OUT "$all{$fas}{self}{hit}\n";
       print OUT "$_\n" for keys %only;
       #print OUT "$_\n" for keys %mulp;
       #print OUT "$_\n" for keys %other;
    }
    
}
close OUT;