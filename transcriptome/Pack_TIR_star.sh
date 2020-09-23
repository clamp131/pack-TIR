###build STAR index
nohup STAR --runThreadN 10 --runMode genomeGenerate --genomeDir /rd/mahj/hg38/genome --genomeFastaFiles xenTro9.fa   --limitGenomeGenerateRAM 100000000000 &
####STAR align
for j in `ls *.sra`
do 
	i=`basename $j .sra`
	## fastq-dump raw sra files
	fastq-dump --split-3 $i.sra 
	#####trim reads
	nohup  trim_galore --paired ${i}_1.fastq ${i}_2.fastq 
	######mapping
	STAR --runThreadN 10 --genomeDir /rd/mahj/OtherSpecies/allMis1/genome/  --readFilesIn ${i}_1_val_1.fq ${i}_2_val_2.fq    --outFileNamePrefix  STAR_result/${i}  --outFilterIntronMotifs None --outSAMtype  BAM SortedByCoordinate  
	#####index
	samtools index $i.bam
done
####filter reads
for i in `cat list|awk '{print $3}'`;do echo $i; for j in `ls *bam`;do samtools view $j $i|awk '$6!~/N/'|grep "NH:i:1"|grep -wE "nM:i:0|nM:i:1|nM:i:2"; done;done >sum_reads