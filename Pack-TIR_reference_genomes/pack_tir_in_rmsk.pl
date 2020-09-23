#!/usr/bin/perl -w
use strict;

my $file1=$ARGV[0];
my $file2=$ARGV[1];
my $out1=substr($ARGV[0],0,index($ARGV[0],'.')).'.4out';
my $out2=substr($ARGV[0],0,index($ARGV[0],'.')).'.4fas';

my %count=();
my %count1=();
open FILE,"$file1";
while(<FILE>){
    $_=~s/[\(\)]//g;
    my @line=split/\t/,$_;
    if($line[11] eq "DNA" || $line[11] eq "RC"){
	my $id=$line[5].','.$line[6].','.$line[7];
	$count{$line[5]}{$line[6]}{chr}=$line[5];
	$count{$line[5]}{$line[6]}{start}=$line[6];
	$count{$line[5]}{$line[6]}{end}=$line[7];
	$count{$line[5]}{$line[6]}{strand}=$line[9];
	$count{$line[5]}{$line[6]}{name}=$line[10];
	$count{$line[5]}{$line[6]}{class}=$line[11];
	$count{$line[5]}{$line[6]}{family}=$line[12];
	$count{$line[5]}{$line[6]}{r_start}=$line[13];
	$count{$line[5]}{$line[6]}{r_end}=$line[14];
	$count{$line[5]}{$line[6]}{r_left}=0-$line[15];
	if($line[9] eq '-'){
	    $count{$line[5]}{$line[6]}{r_start}=$line[15];
	    $count{$line[5]}{$line[6]}{r_left}=0-$line[13];
	}
    }

    
}
close FILE;

open FILE,"$file2";
my %fas=();
my $name='';
while(<FILE>){
    chomp $_;
    if($_=~/^>/){
	$name=substr($_,1,);
    }else{
	$fas{$name}.=$_;
    }
}
close FILE;

open OUT,">$out1";
open OUT1,">$out2";
my $tsj1=0;
my $tsj2=0;
my $tsj3=0;
for my $chr(sort keys %count){
    #for my $start1(sort {$a <=> $b} keys %{$count{$chr}}){
    my @start=sort {$a <=> $b} keys %{$count{$chr}};
    for (my $i=0;$i<$#start;$i+=1){
	my $start1=$start[$i];
	LINE:for (my $j=$i+1;$j<=$#start;$j+=1){
	    my $start2=$start[$j];
	#LINE:for my $start2(sort {$a <=> $b} keys %{$count{$chr}}){
	    #if($start1 < $start2){
		if($count{$chr}{$start1}{name} eq $count{$chr}{$start2}{name} && $count{$chr}{$start1}{strand} eq $count{$chr}{$start2}{strand}){
		    $tsj1++;
		    if($count{$chr}{$start2}{start}-$count{$chr}{$start1}{end}<=5000 && $count{$chr}{$start2}{start}-$count{$chr}{$start1}{end}>=100){
			$tsj2++;
		    if($count{$chr}{$start1}{strand} eq "+"){
		    
			if($count{$chr}{$start1}{r_start} <=10 && $count{$chr}{$start2}{r_left} <=10){
			    my $fas=substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start1}{end},$count{$chr}{$start2}{start}-$count{$chr}{$start1}{end});
			    my $n_rep=$fas;
			    $n_rep=~ s/[atcgN]//g;
			    if(length($n_rep)>=100 && length($n_rep)/length($fas)>=0.8){
				$tsj3++;
				print OUT1 ">$chr,$start1,$count{$chr}{$start1}{end},$chr,$start2,$count{$chr}{$start2}{end}\n$fas\n";
				print OUT "$count{$chr}{$start1}{chr}\t$count{$chr}{$start1}{start}\t$count{$chr}{$start1}{end}\t$count{$chr}{$start1}{strand}\t$count{$chr}{$start1}{name}\t$count{$chr}{$start1}{class}\t$count{$chr}{$start1}{family}\t$count{$chr}{$start1}{r_start}\t$count{$chr}{$start1}{r_end}\t$count{$chr}{$start1}{r_left}\t";
				print OUT "$count{$chr}{$start2}{chr}\t$count{$chr}{$start2}{start}\t$count{$chr}{$start2}{end}\t$count{$chr}{$start2}{strand}\t$count{$chr}{$start2}{name}\t$count{$chr}{$start2}{class}\t$count{$chr}{$start2}{family}\t$count{$chr}{$start2}{r_start}\t$count{$chr}{$start2}{r_end}\t$count{$chr}{$start2}{r_left}\n";
			    }
			}
		    }else{
			if($count{$chr}{$start1}{r_left} <=10 && $count{$chr}{$start2}{r_start} <=10){
			    my $fas=substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start1}{end},$count{$chr}{$start2}{start}-$count{$chr}{$start1}{end});
			    my $n_rep=$fas;
			    $n_rep=~ s/[atcgN]//g;
			    if(length($n_rep)>=100 && length($n_rep)/length($fas)>=0.8){
				$tsj3++;
				print OUT1 ">$chr,$start1,$count{$chr}{$start1}{end},$chr,$start2,$count{$chr}{$start2}{end}\n$fas\n";
				print OUT "$count{$chr}{$start1}{chr}\t$count{$chr}{$start1}{start}\t$count{$chr}{$start1}{end}\t$count{$chr}{$start1}{strand}\t$count{$chr}{$start1}{name}\t$count{$chr}{$start1}{class}\t$count{$chr}{$start1}{family}\t$count{$chr}{$start1}{r_start}\t$count{$chr}{$start1}{r_end}\t$count{$chr}{$start1}{r_left}\t";
				print OUT "$count{$chr}{$start2}{chr}\t$count{$chr}{$start2}{start}\t$count{$chr}{$start2}{end}\t$count{$chr}{$start2}{strand}\t$count{$chr}{$start2}{name}\t$count{$chr}{$start2}{class}\t$count{$chr}{$start2}{family}\t$count{$chr}{$start2}{r_start}\t$count{$chr}{$start2}{r_end}\t$count{$chr}{$start2}{r_left}\n";
			    }
			}
		    }
		    }
		}
	    if($count{$chr}{$start2}{start}-$count{$chr}{$start1}{end}>5000){
		last LINE;
	    }
	}
    } 
}

print "$tsj1\n$tsj2\n$tsj3\n";