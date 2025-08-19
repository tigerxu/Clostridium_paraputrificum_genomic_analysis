#!/usr/bin/perl -w
use strict;
use Bio::AlignIO;
 die "Usage: $0 resultdir > output" unless (@ARGV == 1); 

print "Gene\tAlignment_Length\tSequence_no\tidentity(overal)\tidentity(average)\tLength_ungapped_alignment\n";
  my $dir1 = "./"."$ARGV[0]";
  opendir(DIR, $dir1) || die "Can't open directory $dir1\n";
my @store_array = ();
@store_array = readdir(DIR);
my $name = '';
my @array = ();
foreach my $file (@store_array) {
	@array = ();
 		next unless ($file =~ /^(\S+)\.aln$/);
 	if ($file =~ /^(\S+)\.aln$/){
		$name = $1;
	} 

my $in = Bio::AlignIO->new(-format => 'fasta', -file   => "$dir1/$file");

my $aln = $in->next_aln;
print "$name\t";
print $aln->length,"\t";
print $aln->no_sequences,"\t";
print $aln->overall_percentage_identity, "\t";      
print $aln->average_percentage_identity, "\t";      

my $ungapped = $aln->remove_gaps;              
print $ungapped->length,"\n";

#$out->write_aln($aln);
}


