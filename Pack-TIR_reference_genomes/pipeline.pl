#!/usr/bin/perl -w
use strict;

open FILE,"animal_list";
while(<FILE>){
    chomp $_;
    #my @line=split/\t/,$_;
    print "$_\n";
    sleep 2;
    my $name1=$_.".rmsk"; #the repeatmasker file downloaded from UCSC
    my $name2=$_.'.fa.masked'; # the masked genome file downloaded from UCSC
    my $name3=$_.'.4fas';
    my $name4=$_.'.4psl';
    chdir "$_"; #enter the fold containing the above two files
    `perl ../pack_tir_in_rmsk.pl $name1 $name2`;
    `blat $name2 $name3 -noHead -stepSize=5 -repMatch=2253 -minScore=100 -minIdentity=90 $name4`;
    `perl ../filter.pl  $name1 $name2`;
    `perl ../final.pl  $name1 $name2`;

    chdir "..";

}
close FILE;
