#! usr/bin/perl
#use strict;
die "Usage: $0 fastaseq ortholog.list > seq.out" unless (@ARGV == 2);

open(GENE,$ARGV[0])or die "cannot open $ARGV[0]\n";

open(LIST,$ARGV[1])or die "cannot open $ARGV[0]\n";


my %hash = ();
my $name = '';
my $anno = '';
my $count = 0;
my $cluster = '';

local $/ = '>';
my $len = 0;
my %vash = ();
my %seq = ();

while(<GENE>){
	chomp;
	if (/^$/){next;}
        my ($head,$sequence) = split(/\n/,$_,2);
        if($head =~ /^(\S+)/){
        	$name = $1;
        }
        $sequence =~ s/\n//g;
		$len = length $sequence;
		$vash{$name} = $len;
		$seq{$name} = "$head\n$sequence";
}
close (GENE);

my $symbol = '';
my $ogid = '';

while(<LIST>){                              
	chomp;
	my @arr = split(/\n/,$_);
	shift @arr;
		for my $ele (@arr){
		$ele =~ tr/,/ /;
		$ele =~ s/\"//g;
		 my @gene = split(/\s+/, $ele);
		 $ogid = shift @gene;
		 $symbol = shift @gene;
		 #warn "$cluster\n";
		 $cluster = "$ogid $symbol";

		  for my $id (@gene){
		   if($id ne '*'){
		     $hash{$cluster}{$id} = $vash{$id};
			 }
	}
}
}
close LIST;


for $family (sort keys %hash){
   #warn "$family\n"; 
   for $role (sort {%{$vash{$b}} <=> %{$vash{$a}}} keys %{$hash{$family}}){    # this function has been tested. Right
      #warn "$role\n";
	  print ">$family $seq{$role}\n";
	  last;
	  }
	}
