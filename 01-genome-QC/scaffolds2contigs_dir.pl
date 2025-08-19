#!/usr/bin/perl
use strict;

die "Usage: $0 inputdir outputdir" unless (@ARGV == 2);

my $inputdir = shift @ARGV;
my $outputdir= shift @ARGV;
 system ("mkdir $outputdir");


my @aln_array;
opendir(DIR, $inputdir) || die $!;
my $flag = 0;

for my $file ( readdir(DIR) ) {
	next unless ($file =~ /^(.*?).fna/); 
 if( $file =~ /^(.*?)\./) { 
   my $name = $1;
   $flag = 0;
   
open(IN, "$inputdir/$file") || die "Incorrect file $file. Exiting...\n";
open(OUT, ">$outputdir/$file") || die "can't open file:$!\n";


my ($seq, $name)=('','');
while(<IN>){
  chomp;
  my $line = $_;
  $seq.= uc($line) if(eof(IN));
  if (/\>(\S+)/ || eof(IN)){
    if($seq ne ''){
      my @seqgaps = split(/[N]{3,}/, $seq);
      if($#seqgaps > 0){
        my $ctgcount=0;
        foreach my $ctgseq (@seqgaps){
          $ctgcount++;
          print OUT "$name contig$ctgcount (size=".length($ctgseq).")\n$ctgseq\n";
        }
      }else{
      	$seq =~ s/[N]{2,}$//g;
        print OUT "$name\n$seq\n";
      }
    }
    $seq='';
    $name = $_;
  }else{
    $seq.=uc($line);
  }
}
}
}