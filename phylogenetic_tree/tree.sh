###multiple sequence alignment
muscle3.8.31_i86linux32 -in 14capture.fas -out 14capture_aln.fas 
convertFasta2Phylip.sh  14capture_aln.fas >14capture_aln.phy
####build tree use maximum likelihood
raxmlHPC -f a -x 12345 -p 12345 -# 1000 -m GTRGAMMA -s 14capture_aln.phy -n 14capture