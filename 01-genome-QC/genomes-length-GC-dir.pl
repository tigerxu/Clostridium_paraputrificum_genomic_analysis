#!/usr/bin/perl -w
use strict;

 die "Usage: $0 resultdir > gccontent.tsv" unless (@ARGV == 1); 
 use Bio::SeqIO;


  my $dir1 = "./"."$ARGV[0]";
  opendir(DIR, $dir1) || die "Can't open directory $dir1\n";
my @store_array = ();
@store_array = readdir(DIR);
my $name = '';
my @array = ();

print "Strain_ID\tLength(bp)\tGC(%)\tNs_Numbers\tContigs_Numbers\n";

foreach my $file (@store_array) {
	@array = ();
 		next unless ($file =~ /^(\S+)\.fna/);
 		#next unless ($file =~ /^(\S+)\.fasta/);

 	if ($file =~ /^(.*)\.fna/){
		$name = $1;
	} 

my $in = new Bio::SeqIO(-format => 'fasta', -file => "$dir1/$file");
my $count = 0;
my $len = 0;
my $ns = 0;
my $gc = 0;

while( my $seq = $in->next_seq ) {
	$count++;
	my $name = $seq->display_id;
	$len += $seq->length;
  my $sequence = $seq->seq;
  $gc += ($sequence =~ tr/GCgc//);
  $ns += ($sequence =~ tr/Nn//);
  my $genomename = $seq->desc;
}
  $gc = sprintf("%.1f", $gc/$len*100);

   print "$name\t$len\t$gc\t$ns\t$count\n";

}
