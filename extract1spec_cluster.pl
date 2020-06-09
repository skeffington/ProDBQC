#extract1spec_cluster.pl

use warnings;
use strict;

my $usage = "perl -S extract1spec_cluster.pl [cluster file in] [spectra names out]\n";

my $clusin = shift or die $usage;
my $specout = shift or die $usage;

open(CIN, '<', $clusin);
open(SOUT, '>>', $specout);

{
local $/ = '=Cluster=';
	while (my $record = <CIN>){
		my @lines = split /\R/, $record ;
		my $title;      
		for my $line (@lines){
			$line =~ s/\R//g ;
			if($line =~ /^SPEC\t.*title=([^\t]*)/g){
				$title = $1;
				last;
			}
		}
		print SOUT "$title\n";
	}
}

close CIN;
close SOUT;

