
for i in `cat seqs1`
do
	##prpare the reads
	cat $i.reads|grep -w "NH:i:1"|cat Header $i.reads|samtools view -Sb -|samtools sort  - -o $i.sort.bam; samtools index $i.sort.bam;samtools sort -n $i.sort.bam -o $i.N.bam
	samtools fastq  -1 $i.1.fastq -2 $i.2.fastq -0 /dev/null -s /dev/null   -N $i.N.bam
	###strandness assemble
	nohup Trinity --seqType fq --max_memory 20G --CPU 4 --left $i.1.fastq --right  $i.2.fastq --SS_lib_type RF --output $i.trinity --full_cleanup &
done
