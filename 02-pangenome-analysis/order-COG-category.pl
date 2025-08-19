#! /usr/bin/perl -w
use strict;

die "Usage:  $0 countCOG-cat4distributed-genes.txt fun2003-2014.tab > orderCOG_cat.txt \n" if(@ARGV != 2);

open(FH, $ARGV[0])|| die "can't open file:$!\n";
open(LIST, $ARGV[1])|| die "can't open file:$!\n";

my $dumpline = <FH>;
print "$dumpline";
my %hash = ();

# C       Energy production and conversion        21      3.3

while (<FH>){
	chomp;
	if(/^(\S+)\s+(.*)\s+(\S+)\s+(\S+)/){   
       $hash{$1} = "$3\t$4\n";
	}
}
close FH;

#MCC	Multiple COG categories
my $id = '';
<LIST>;

while (<LIST>) {
	chomp;
	if(/^(\S+)\s+(.*)$/){
		$id = $1;
		if (exists $hash{$id}) {
			print "$_\t$hash{$id}";
		}else{
		print "$_\t0\t0\n";
	}
}
}

