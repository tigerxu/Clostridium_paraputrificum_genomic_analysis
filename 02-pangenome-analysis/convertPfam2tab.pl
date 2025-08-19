#! usr/bin/perl
#use strict;
die "Usage: $0 pfam.tbl pangenome-all-OG-ID.txt > pfam-result-summary.tab" unless (@ARGV == 2);

open(LIST, $ARGV[0]) or die "cannot open $ARGV[0]\n";
open(FILE, $ARGV[1]) or die "cannot open $ARGV[1]\n";

my %hash = ();
my $count = 0;

while(<LIST>){                               #each line contains only one word
	chomp;
   	if(/^(\S+)\s+(\S+)\s+(\S+)\s+.*?\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+(.*)$/){

     my $funct = $1;
	   my $id = $2;
	   my $name = $3;
	   my $desc = $4;
	   $id =~ s/\.\d+//g;
	 
	 push @{$hash{$name}}, "$funct ($id) $desc";
}
}
close LIST;

my %vash = ();
my $ogid = '';

my $dumpline = <FILE>;

while(<FILE>){
	chomp;
	if (/^(\S+)/) {
		$ogid = $1;
		$vash{$ogid} = $_;
	}
}
close FILE;

print "ID\tPfam_annotation\n";
for my $ele (sort keys %vash){
	if(exists $hash{$ele}){
		print "$ele\t", join("; ", @{$hash{$ele}}), "\n";
	}else {
		print "$ele\t-\n";
	}
}

