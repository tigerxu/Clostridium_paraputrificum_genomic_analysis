#! /usr/bin/perl -w
use strict;

die "Usage:  $0 GD01vsCOG2014.tab fun2003-2014.tab > countCOG_cat.txt \n" if(@ARGV != 2);

open(FH, $ARGV[0])|| die "can't open file:$!\n";
open(LIST, $ARGV[1])|| die "can't open file:$!\n";

my $dumpline = <FH>;
my %hash = ();
my $count = 0;

while (<FH>){
	chomp;
	if(/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+/){   
      my $category = $4;
	   $hash{$category}++;
	}
}
close FH;

my %vash = ();

while (<LIST>) {
	chomp;
	if(/^(\S+)\s+(.*)$/){
		$vash{$1} = $2;
	}
}

my $multi = 0;
print "ID\tCOG category\tNumber of genes\tPercent (%)\n";

my $total = 0;
for my $tag (sort keys %hash){
	$total += $hash{$tag};
}

my $percent = 0;

for my $ele (sort keys %hash){
	my $len = length $ele;
	if($len > 1){
		$multi += $hash{$ele};
  	}else{
  		$percent = sprintf("%.5f", $hash{$ele}/$total*100);
  		print "$ele\t$vash{$ele}\t$hash{$ele}\t$percent\n";
	}
}
    		$percent = sprintf("%.5f", $multi/$total*100);
  print "MCC\t$vash{'MCC'}\t$multi\t$percent\n";