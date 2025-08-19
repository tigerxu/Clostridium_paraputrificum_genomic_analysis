#! /usr/bin/perl -w
  use Statistics::Distributions;
    
  open (FILE,"$ARGV[0]")||die "can't open file:$!\n";
  my $dumpline = <FILE>;
  chomp $dumpline;
  print "$dumpline\tp-value (chi-square with df = 2)\n";
  while (<FILE>){
  	chomp;
  	#if (/^(\S+)\s+(\S+)/){
  	if (/\s+(\S+)$/){
  		$chisprob=Statistics::Distributions::chisqrprob (2,$1);
  print "$_\t$chisprob\n";
     }
   }
   close FILE;
  