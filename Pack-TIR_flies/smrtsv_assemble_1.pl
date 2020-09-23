#!/usr/bin/perl -w
use strict;

#extract the reads of candidate SVs
open FILE,"candidates.bed";
chdir "tmp";
while(<FILE>){
    my @line=split/\t/,$_;
    my $dir=$line[0]."-".$line[1]."-".$line[2];
    unless (-e $dir){
    mkdir "$dir";
    chdir "$dir";
    my $pos=$line[0].":".$line[1]."-".$line[2];
    my @alignment=`samtools view -q 30 /rd/tansj/427/alignments/0.bam $pos `;
    my $out="reads.fastq";
    open OUT,">$out";
    foreach my $read(@alignment){
	my @line1=split/\t/,$read;
	print OUT "\@$line1[0]\n$line1[9]\n\+\n$line1[10]\n";
    }
    close OUT;
    #get the local region in fastq format############    
    open OUT,">reference_region.bed";
    print OUT "$line[0]\t$line[1]\t$line[2]\n";
    close OUT;
    `bedtools getfasta -fi /rd/tansj/427/dmel_6.10.fa -bed reference_region.bed -fo reference_region.fasta`;
    #get the local reference region sequence############
    chdir "..";
    }
}
chdir "..";