Calculate nucleotide diversity:   
---
	1. randomly choose the same number of reference lines to that of the X-linked or 3R-linked Ssk-FB4 copies   
		perl getrandom.pl X_ind_75_exclude X_ind_75 X_ind_75_exclude_rand  
	2. calculate Pi in a window  
		perl calInsertPi.pl X_ind_75_exclude_rand X_ind_75 X 2639224 50000 insertX_50K.pi    
	3. arrange files used for graphical presentation  
		perl normal.pl Xref-50000.windowed.pi Xalt-50000.windowed.pi  X-50000.pi  
	4. draw a dot-line plot to show the difference between the lines containing the Ssk-FB4 copy or not  
		Rscript pi.R   

Random sampling to verify the pattern:   
---
	1. randomly sample 1,000 synonymous sites with the same chromosome and similar (95%~105% fold) allele frequency and recombination rate as the two Ssk-FB4 loci; keep the refnum=altnum; the output file is sum_X_1000; output format: chr pos refpi altpi   
 		perl simulate.pl 1000  
	2. draw a simulation plot  
		Rscript sim.R  
