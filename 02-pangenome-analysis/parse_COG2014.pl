#!/usr/bin/perl
use strict;

use Bio::SearchIO;
die "Usage:  $0 cog2003-2014.csv cognames2003-2014.tab output.blast > besthit.tab \n" if(@ARGV != 3);

open (LIST, "$ARGV[0]") || die "can't open the list:$!\n";

my %hash = ();

while(<LIST>){
	chomp;
  if(/^(\d+),.*?,(COG\d+),/){
  	$hash{$1} = $2;
  }
}
close LIST;

open (DATA, "$ARGV[1]") || die "can't open the data file:$!\n";

my %vash = ();
while(<DATA>){
	chomp;
	if(/^(\S+)\s+(.*)$/){
		$vash{$1} = $2;
	}
}
close DATA;


my $file = $ARGV[2];
my $in = Bio::SearchIO->new(-format => 'blast',
                            -file    => $file);
print "Query\tSubject\tCOG_code\tCOG_class\tCOG_family\n";

my $count = 0;
my $number = 0;

while( my $r = $in->next_result ) {          
  $count = 0;
  $number++;
  # if no hit against COG
  	if ($r->num_hits < 1){
  	 print $r->query_name,"\t-\t-\t-\t-\n";
  	 next;
  }
  while( my $h = $r->next_hit ) {            
    my $hitlen = $h->length;
    while( my $hsp = $h->next_hsp ) { 
     my $subject = $h->name;
     if ($subject =~ /^gi\|(\d+)/){
     	my $gi = $1;
     if ($count < 1){
     	if (exists $hash{$gi}) {
     		 	my $cogid = $hash{$gi};
      print $r->query_name,"\t", $gi, "\t", $cogid, "\t", $vash{$cogid}, "\n";
    }else {
    	warn $r->query_name, "\n";
    	print $r->query_name,"\t-\t-\t-\t-\n";

    }
     $count++;
     }
    }
    last;
     }    
  }
}

