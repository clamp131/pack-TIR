#! /usr/bin/perl

use warnings;
use strict;
##########################################################
#####get the reference line randomly with the same number with the X or 3R insertion 
###usage: perl getrandom.pl X_ind_75_exclude X_ind_75 X_ind_75_exclude_rand
###############################################################
my $dir="/home/mahj/transposon/plot/ssk/redoSS/";
chdir $dir;
open IN1, "$ARGV[0]";
open IN2, "$ARGV[1]";
open OUT,">$ARGV[2]";
my @LINE2=<IN2>;
my $n1=@LINE2;
my @LINE;
my $n2=0;
while (<IN1>) {
    chomp $_;
    $LINE[$n2]=$_;
    $n2++;
}
print $n1."\t".$n2."\n";

srand(50);
my @rand=&rand_num($n1,$n2);

foreach my $sub(@rand) {
    print $sub."\t".$LINE[$sub]."\n";
    print OUT $LINE[$sub]."\n";
 }


##random choose number from array
sub rand_num{
 #   my $n=shift;
    #n1 is the random number I need, n2 is the whole length of the file
    my ($n1,$n2)=@_;
    my %a;
    my @b;
    while ($#b+1<$n1) {
        my $r=int rand($n2);
        push @b, $r if(!exists $a{$r});
        $a{$r}=1;
    }
    return @b;
}



##median function
sub mid{
    my @list = sort{$a<=>$b} @_;
    my $count = @list;
    if( $count == 0 )
    {
        return undef;
    }
    if(($count%2)==1){
        return $list[int(($count-1)/2)];
    }
    elsif(($count%2)==0){
        return ($list[int(($count-1)/2)]+$list[int(($count)/2)])/2;
    }
}

close IN1;
close IN2;
close OUT;
