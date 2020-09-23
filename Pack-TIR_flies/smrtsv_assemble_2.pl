#!/usr/bin/perl -w
use strict;


#process of local assembling. after run this perl script, bash this '.sh' file
chdir "tmp";
my $tsj=0;
my @tsj=();
for my $folder(glob "*"){
    $tsj++;
    push (@tsj,$folder);
    if($tsj%100== 0){
	my $out=$tsj.'.sh'; 
	open OUT,">../$out"; 
	
    print OUT "#!/bin/bash\n";
    print OUT "cd \"tmp\"\n";
	for (my $i=0;$i<=$#tsj;$i++){
	    #print OUT "cd \"$tsj[$i]\"\n"; #
	    print OUT "canu -assemble -p reads -d reads genomeSize=60k useGrid=false -pacbio-corrected reads.trimmedReads.fasta.gz useGrid=false gnuplotTested=true ovsMethod=sequential maxMemory=100g maxThreads=1\n";
	    print OUT "blasr ./reads/reads.contigs.fasta reference_region.fasta -clipping subread -out /dev/stdout -sam -affineAlign -affineOpen 8 -affineExtend 0 -bestn 1 -maxMatch 30 -sdpTupleSize 13 | samtools view -q 30 - | awk 'OFS=\"\\t\" {{ sub(/:/, \"-\", \$3); num_of_pieces=split(\$3, pieces, \"-\"); \$3 = pieces[1]; \$4 = pieces[2] + \$4; print }}' | sed 's/RG:Z:\\w\+\\t//' > consensus_reference_alignment.sam\n";
	    print OUT "awk -v v=$tsj[$i] '{\$1=\$1\"_\"v;printf \$1;for(m=2;m<=NF;m++){printf \"\\t\"\$m;} print \"\"; }' consensus_reference_alignment.sam >consensus_reference_alignment2.sam\n";
	    print OUT "cat consensus_reference_alignment2.sam >> ../../consensus_reference_alignment.tmp4.sam\n";
	    print OUT "rm -fr reads/\n";
	    #print OUT "cd \"..\"\n";
	}
	close OUT;
	@tsj=();
    }
    
}
chdir "..";