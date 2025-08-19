#!/usr/bin/perl -w
use strict;
# Xu Zhuofei, 2024-07-20
 die "Usage: $0 list faa-dir outputdir" unless (@ARGV == 3); 
    use Bio::SeqIO;

open(LIST,$ARGV[0])or die "cannot open $ARGV[0]\n";

my %hash = ();

while(<LIST>){
	chomp;
	$_ =~ s/\r//g;               
	if(/^(\S+)\s*/){
	$hash{$1} = $1;
}
}
close LIST;
	
  my $dir1 = "./"."$ARGV[1]";
  my $dir2 = "./"."$ARGV[2]";
  system("mkdir $dir2");
  
  opendir(DIR, $dir1) || die "Can't open directory $dir1\n";
my @store_array = ();
@store_array = readdir(DIR);
my $name = '';
my @array = ();
foreach my $file (@store_array) {
	@array = ();
 		next unless ($file =~ /^(\S+)\.fa/);
 	if ($file =~ /^(.*?)\./){
		$name = $1;
		if(exists $hash{$name}){
			system("cp $dir1/$file $dir2/");
			}
	}
} 

