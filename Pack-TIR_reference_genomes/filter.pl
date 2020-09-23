#!/usr/bin/perl -w
use strict;

my $file=substr($ARGV[0],0,index($ARGV[0],'.')).'.4psl';
my $out=substr($ARGV[0],0,index($ARGV[0],'.')).'.4filter';

open FILE,"$file";

my %all=();
my %count=();
while(<FILE>){
    chomp $_;
    my @line=split/\t/,$_;
    $count{$line[9]}++;
    $all{$line[9]}{$_}++;
}
close FILE;

open OUT,">$out";
for my $id(sort keys %count){
    if($count{$id}>=2){
	for my $psl(sort keys %{$all{$id}}){
	    print OUT "$psl\n";
	}
    }
}
