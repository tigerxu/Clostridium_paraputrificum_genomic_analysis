#!/usr/bin/perl

use strict;
use warnings;

#core Perl modules
use Getopt::Long;

#locally-written modules
BEGIN {
    select(STDERR);
    $| = 1;
    select(STDOUT);
    $| = 1;
}

# get input params
my $global_options = checkParams();

my $inputdir;
my $genomenumber;

$inputdir = &overrideDefault("inputfile.dir",'inputdir');
# $genomenumber = &overrideDefault("genome.number",'genomenumber');


######################################################################
# CODE
######################################################################

my $dir = "./"."$inputdir";

opendir(DIR, $dir) || die "Can't open directory $dir\n";
my @array = ();
@array = readdir(DIR);

my $name = '';

foreach my $file (@array){
	next unless ($file =~ /^\S+.codon.aln$/);
	if($file =~ /^(\S+).codon.aln$/){
	 $name = $1;
	 }
	 $genomenumber = 0;
	 
	 open(FASTA, "$dir/$file")|| die "can't open the filtered alignment file:$!\n";
    while(<FASTA>){
    	 chomp;
    	 if(/^>/){
    	 	$genomenumber++;
    	 }
    }
    close FASTA;
	
		my $noseqcon = int ($genomenumber/2 +1);
	system ("Gblocks $dir/$file -t=c -e=.fa -b1=$noseqcon -b2=$noseqcon -b3=8 -b4=5 -b5=n");
	# the output .fa format contains interleaved blank space per line, so delete them and create a new fasta format file
	open(ALN, "$dir/$file.fa")|| die "can't open the filtered alignment file:$!\n";
	open(OUTP, ">$dir/$name.gblock.codon.aln");
	
	while(<ALN>){
	 chomp;
	 $_ =~ s/\s+//g;
	 print OUTP "$_\n";
	 }
}
closedir (DIR);

######################################################################
# TEMPLATE SUBS
######################################################################
sub checkParams {
    #-----
    # Do any and all options checking here...
    #
    my @standard_options = ( "help|h+", "inputdir|i:s");
       #my @standard_options = ( "help|h+", "inputdir|i:s", "genomenumber|t:s");

    my %options;

    # Add any other command line options, and the code to handle them
    # 
    GetOptions( \%options, @standard_options );
    
	#if no arguments supplied print the usage and exit
    #
    exec("pod2usage $0") if (0 == (keys (%options) ));

    # If the -help option is set, print the usage and exit
    #
    exec("pod2usage $0") if $options{'help'};

    # Compulsosy items
    #if(!exists $options{'infile'} ) { print "**ERROR: $0 : \n"; exec("pod2usage $0"); }

    return \%options;
}

sub overrideDefault
{
    #-----
    # Set and override default values for parameters
    #
    my ($default_value, $option_name) = @_;
    if(exists $global_options->{$option_name}) 
    {
        return $global_options->{$option_name};
    }
    return $default_value;
}

__DATA__

=head1 NAME

    gblocks.pl

=head1 COPYRIGHT

   Copyright (C) 2024 Zhuofei Xu

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

=head1 DESCRIPTION

	Remove potentially unreliable alignment regions using Gblocks.

=head1 SYNOPSIS

script.pl  -i [-h]

 [-help -h]                Displays this basic usage information
 [-inputdir -i]            Input directory containing raw alignment file to be tested 
=cut

