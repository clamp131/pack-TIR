
#####build specific index for each line
for i in 208 379 399 427 517 799;do echo $i; kallisto index -i ${i}_new.idx ${i}_new.fasta ;done


##### use kallisto to do quantificaiton
d="/share_bio/unis1/ioz_group/lengl/work/ddproject/84_RNASeq"
D="/share_bio/unis1/ioz_group/mahj/RNA_Leng/FB4/"
cd $D
for i in `cat names`
do
a=`echo $i|awk -F "-" '{print $1}'`
echo $a
case $a in
    208)
        cd 208
        mkdir $i
        kallisto quant -i 208_new.idx -o $i -b 100 ${d}/${i}*.R1.clean.fastq.gz  ${d}/${i}*.R2.clean.fastq.gz
      ;;
    517)
        cd 517
        mkdir $i
        kallisto quant -i 517_new.idx -o $i -b 100 ${d}/${i}*.R1.clean.fastq.gz  ${d}/${i}*.R2.clean.fastq.gz
     ;;
    379)
        cd 379
        mkdir $i
        kallisto quant -i 379_new.idx -o $i -b 100 ${d}/${i}*.R1.clean.fastq.gz  ${d}/${i}*.R2.clean.fastq.gz
    ;;
    399)
        cd 399
        mkdir $i
        kallisto quant -i 399_new.idx -o $i -b 100 ${d}/${i}*.R1.clean.fastq.gz  ${d}/${i}*.R2.clean.fastq.gz
    ;;
    427)
        cd 427
        mkdir $i
        kallisto quant -i 427_new.idx -o $i -b 100 ${d}/${i}*.R1.clean.fastq.gz  ${d}/${i}*.R2.clean.fastq.gz
    ;;
    799)
        cd 799
        mkdir $i
        kallisto quant -i 799_new.idx -o $i -b 100 ${d}/${i}*.R1.clean.fastq.gz  ${d}/${i}*.R2.clean.fastq.gz
    ;;
esac
       cd $D
done

