#! /usr/bin/perl

use 5.010;
use strict;

##########################################################
my ($full_name_file, $abbr_name_file) = @ARGV;
my (%abbr, @abbr_file);

open(my $IN,'<',"$full_name_file");
while(<$IN>){
	chomp;
	if (/^>/){
		$_ =~ /(?<=^>)(.+)([NY]P_.+)/;
		$abbr{$2}=$1.$2;
	}
}

open(my $IN,'<',"$abbr_name_file");
while(<$IN>){
	for my $ele (keys %abbr){
		$_ =~ s/$ele/$abbr{$ele}/g;
	}
	push @abbr_file, $_;
}

print "@abbr_file";


