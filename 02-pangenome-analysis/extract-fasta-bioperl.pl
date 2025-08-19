#! /usr/bin/perl -w
use strict;

die "Usage:  $0 seqs.fasta list > selected-fasta.faa \n" if(@ARGV != 2);

my %hash = ();

use Bio::SeqIO;

my $input = $ARGV[0];
my $in = new Bio::SeqIO(-format => 'fasta', -file => "$input");


while( my $seq = $in->next_seq ) {
	my $seqid = $seq->display_id;
	my $func = $seq->description;
	my $aa = $seq->seq;
	$hash{$seqid} = $func."\n".$aa;
}

open(LIST,$ARGV[1])or die "cannot open $ARGV[1]\n";
my $dumpline = <LIST>;

while(<LIST>){
	chomp;
	if (/^(\S+)/){
		my $name = $1;
		print ">$name $hash{$name}\n";
	}
}
close (LIST);