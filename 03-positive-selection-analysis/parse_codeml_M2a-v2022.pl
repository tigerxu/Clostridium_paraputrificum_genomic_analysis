 #!/usr/bin/perl -w
 use strict;
die "Usage: $0 dir outputfile " unless (@ARGV == 2);
  
  open (OUT, ">$ARGV[1]") or die;	
  print OUT "OG_ID\tNumber_of_parameters\tLikelihood (M2a)\tProportion of PSSs\tOmega (w)\tPositively selected sites";       #extract model1a results

  my $dir = $ARGV[0] || die "need a directory";
  opendir(DIR, $dir) or die;  
my @store_array = ();
@store_array = readdir(DIR);
my $name = '';
my @array = ();

foreach my $file (@store_array) {
	@array = ();
 	next unless ($file =~ /M2$/);
 	if ($file =~ /^(.*?)\.M2/){
		$name = $1;
	} 
  print OUT "\n$name\t";
  
  open(FILE, "$dir/$file") || die "no input file";
  my $flag = 0;
  
  while(<FILE>){
    chomp;
	if(/^lnL\S+\s*\d+\s+np:\s*(\d+)\):\s+(\S+)\s+/){
	  print OUT "$1\t$2\t";
   }
   #p:   0.97908  0.00010  0.02082
   #w:   0.06727  1.00000 10.49238
   if(/^p:\s{3}\S+\s{2}\S+\s{2}(\S+)$/){
     print OUT "$1\t";
	 }
   if(/^w:\s{3}\S+\s+\S+\s+(\S+)$/){
     print OUT "$1\t";
	 }
   #Bayes Empirical Bayes
   if(/^Bayes Empirical Bayes/){
    $flag = 1;
	}
	if($flag == 1){
	 if(/^\s+(\d+)\s+(\S+)\s+\d\.\d+\*/){
	  push @array, $1;
	  }
	  }
	if(/^The grid \(/){
	 $flag = 0;
	 print OUT join(", ", @array);
	 }
}
}

