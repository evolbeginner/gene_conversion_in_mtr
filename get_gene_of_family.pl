#! /usr/bin/perl

use 5.010;
use Getopt::Long;
use extract_gene;
use strict;

####################################################
my (%gene_info, $gene_info_hashref);
my ($input);

GetOptions(
	'input=s'	=>	\$input,
);

die "input file has not been defined" if not defined $input;

$gene_info_hashref = &extract_gene::read_gene_seq($input);
%gene_info = %$gene_info_hashref;

for (keys %gene_info){
	#if ($_ =~ /^Clostridiales/ && $_ !~ /\.\.\.3/){
	if ($_ =~ /^Methanococcales/){
		#next if /15509|39748|09648|38937/;
		next if not /\.\.\.3/;
		print ">$_\n";
		print $gene_info{$_}{seq}."\n";
	}
}


