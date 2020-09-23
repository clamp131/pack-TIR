
1.trim the fastq files
---
	trim_galore --paired SRRXXX_1.fastq SRRXXX_2.fastq
2. digest the genome
---
	hicup_digester  --config digester_example.conf 
3. use bowtie2-build to build the genome index 
---
	/usr/local/bin/bowtie2-build dm6.fa dm6
4. use hicup to do mapping
---
	nohup hicup -config hicup_example.conf&
5. use custom script o calculate the interaction intensity
---
	For positions in the same chromosome:  
		python intrachrom.py  
	For positions in the different chromoe:  
		python interchrom.py  
