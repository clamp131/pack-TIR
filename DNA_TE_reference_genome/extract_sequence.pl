#!/usr/bin/perl -w
use strict;

#extract the suquence of full-length TE or its flanking regions;
my $species='hg38';

#split the genome suquences into chromosomes;
open FILE,"$species.fa";
my $name='';
my %all=();
while(<FILE>){
    chomp $_;
    if($_=~/^>/){
	$name=substr($_,1,);
    }else{
	$all{$name}.=$_;
    }
}
close FILE;
################################

#list file is the target TEs we are interested in;
#format is the same to *.rmsk.fl;
my %all1=();
open FILE,"list";
while(<FILE>){
    my @line=split/\t/,$_;
    $all1{$line[0]}{$line[2]}++;
    #print "$line[2]\n";
}
close FILE;

mkdir "$species";
chdir "$species";
open FILE,"../$species.rmsk.fl";
while(<FILE>){
    my @line=split/\t/,$_;
    #print "$line[11]\n";
    if(defined $all1{$species}{$line[11]}){
	open OUT,">>$line[11].fasta";
	my $fas=substr($all{$line[6]},$line[7],$line[8]-$line[7]); #the sequence of TE;
	#my $fas1=substr($all{$line[6]},$line[7]-20,20); #the flanking 20bp of TE
	#my $fas2=substr($all{$line[6]},$line[8],20); #the flanking 20bp of TE
	#my $fas=$fas1.$fas2; #the flanking 20bp of TE
	if($line[10] eq '-'){
	    $fas=~tr/ATCGatcg/TAGCtagc/;
	    $fas=reverse $fas;
	}
	print OUT ">$line[6],$line[7],$line[8],$line[10]\n$fas\n";
	close OUT;
    }
}
chdir "..";