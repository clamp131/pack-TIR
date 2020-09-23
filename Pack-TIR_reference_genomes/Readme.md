Perl scripts to identify Pack-TIRs in 100 animal reference genomes.

Simply run perl pipeline.pl, it will run pack_tir_rmsk.pl, blat, filter.pl and final.pl, and report the Pack-TIRs in each animal reference genome.
Before run the perl codes, prepare the genome sequence and repeatmasker files. 
Using human as an example, the genome file can be downloaded here: ftp://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/, and the repeatmasker file can be downloaded here:  ftp://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/rmsk.txt.gz
