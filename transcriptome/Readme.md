Expression quantification of Pack-TIRs in human: 
---
	1. use STAR to align reads and filter the result  
		bash Pack_TIR_star.sh  
	2. do strandness de novo local assembly using trinity   
		bash assemble.sh  
Expression of Ssk, Ssk-FB4 and FB4
---
	1. use STAR to align and assemble short reads to check the transcript of Ssk-FB4s  
	2. use kallisto to do quantification  
		bash kallisto.sh  
