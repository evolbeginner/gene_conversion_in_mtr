#! /usr/bin/perl

use 5.010;
use warnings;

my $infile=$ARGV[0];
open(IN,$infile);

while(<IN>)
{
chomp;
next if /^\s+$/;
	if (/^>(.+)/){
		$seq_name=$1;
		}
	else{
		'seq'->{$seq_name}.=$_;
		}
}


foreach (sort keys %seq)
{
	print ">".$_."\n".$seq{$_}."\n";
}



