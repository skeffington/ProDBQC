#!/usr/bin/perl
#del_mgfspectra.pl

#This script takes an mgf file and a list of spectra names and either extracts the specified spectra from the mgf file or extracts the spectra from the mgf file not present in the list of names.

use strict;
use warnings;


my $usage = "perl del_mgfspectra.pl [spectra names] [mgf file] [output file] [mode]\n mode '1' = extract spectra not in the list from the mgf file. mode '2' = extract spectra in the list from mgf file. \n";
my $spec = shift or die $usage;
my $mgfin = shift or die $usage;
my $output = shift or die $usage;
my $mode = shift or die $usage;
my %IDS;

#First read in the IDs from the list into the hash IDS

open (SPECTRA, '<', $spec);

my $inputcount = '0';

while (my $line = <SPECTRA>){
    $line =~ s/\R//g ;
    if ($line =~ /^(.*)/){
		my $name  = "$1";
		#if($inputcount < 5){print "spectra name is $name \n";};
		$IDS{$name} = '1';
		$inputcount++;
    }
}

close SPECTRA;

open (MGF, '<', $mgfin);
open (OUT, '>>', $output);

my $mgfincount = '0';
my $mgfoutcount = '0';
my %MGFIDs;
my %removed;

#MODE '1': Now go through the mgf file and only print records to the output if the name IS NOT in %IDS. Regex's need adjusting for differnt file names at the moment.

if ($mode == '1'){

{
    local $/ = "END IONS";
    while (my $record = <MGF>){
	$mgfincount++;
	my @lines = split /[\n\r]/, $record ;
	my $TI;      
	for my $line (@lines){
	    $line =~ s/\r|\n//g ;
	    #print "line is $line \n";
	    if ($line =~ /^TITLE=(.*)/){ 
		$TI = "$1";
		$MGFIDs{$TI} = '1';
		#print "TI is found as $TI\n";
	    }
	}
	if (exists ($IDS{$TI})){
	    $removed{$TI}= '1';
	    next;
	}else{
	    print OUT  "$record\n";
	    $mgfoutcount++;
	}
    }
}
}

#MODE '2': Now go through the mgf file and only print records to the output if the name IS in  %IDS. Regex's need adjusting for different file names at the moment.

if ($mode == '2'){

{
    local $/ = "END IONS";
    while (my $record = <MGF>){
		$mgfincount++;
		my @lines = split /[\n\r]/, $record ;
		my $TI;      
		for my $line (@lines){
			$line =~ s/\r|\n//g ;
				#if($mgfincount < 5){print "line is $line \n";};
			if ($line =~ /^TITLE=(.*)/){ 
				$TI = "$1";
				#if($mgfincount < 5){print "title is $TI \n";};
			}
		}
		if (exists ($IDS{$TI})){
			print OUT  "$record\n";
			$mgfoutcount++;
		}
    }
}

}


print "IDs in = $inputcount; mgf records in = $mgfincount; mgf records out = $mgfoutcount \n";

close MGF;
close OUT;


