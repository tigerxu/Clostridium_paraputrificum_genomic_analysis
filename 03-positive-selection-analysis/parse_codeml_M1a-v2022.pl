 #!/usr/bin/perl -w
 use strict;
die "Usage: $0 dir outputfile " unless (@ARGV == 2);
  
  open (OUT, ">$ARGV[1]") or die;	
  print OUT "OG_ID\tNumber_of_parameters\tLikelihood (M1a)";       #extract model1a results

  my $dir = $ARGV[0] || die "need a directory";
  opendir(DIR, $dir) or die;  
my @store_array = ();
@store_array = readdir(DIR);
my $name = '';
my @array = ();

foreach my $file (@store_array) {
	@array = ();
 	next unless ($file =~ /M1$/);
 	if ($file =~ /^(.*?)\.M1/){
		$name = $1;
	} 
  print OUT "\n$name\t";
  
  open(FILE, "$dir/$file") || die "no input file";
  while(<FILE>){
    chomp;
	if(/^lnL\S+\s*\d+\s+np:\s*(\d+)\):\s+(\S+)\s+/){
	  print OUT "$1\t$2";
  #warn "$_\n";
 }
}
}

