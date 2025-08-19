
#! /usr/bin/perl -w
  use Statistics::Multtest qw(bonferroni holm hommel hochberg BH BY qvalue);
  use Statistics::Multtest qw(:all);
  use strict;
    
  open (FILE,"$ARGV[0]")||die "can't open file:$!\n";
  my $dumpline = <FILE>;
  chomp $dumpline;
  print "$dumpline\tq-value (BH)\n";
  my %hash = ();
  
  
  while (<FILE>){
  	chomp;
  	#if (/^(\S+)\s+(\S+)/){
  	if (/^(.*)\s+(\S+)$/){
  		my $info = $1;
  		my $pvalue = $2;
	 $hash{$info} = $pvalue; 
     }
   }
 close FILE;
 
 #my $qvalueBH = BH(\%hash);
 #my $qvalueBY = BY(\%hash);

for my $ele (sort keys %hash){
   my $qvalueBH = BH(\%hash)->{$ele};
  print "$ele\t$hash{$ele}\t$qvalueBH\n";
  }