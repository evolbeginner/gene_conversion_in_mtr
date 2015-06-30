#! /usr/bin/perl

use 5.010;

$result_dir="./rbp/rbp_script_dir/rbp/rbp_result/non_taxaname" if not $ARGV[0];

$temperature_file="./rbp/rbp_script_dir/rbp/temperature/sorted_prok_temperature" if not $ARGV[1];

##########################################

my $ref_temperature = &extract_temperature();

&extract_result($ref_temperature);

##################################################
##################################################

sub extract_temperature
{
open (IN,$temperature_file);
while(<IN>){
	chomp;
	my @line=split /\t/;
	$temperature{$line[0]}=$line[1];
}
return (\%temperature);
}

sub extract_result
{
foreach (glob "$result_dir/*"){
	open(IN,$_);
	while(<IN>){
		chomp;
		my @line = split /\t/;
		print $line[5]."\n" if exists $temperature{$line[5]};
	}
	close IN;
}
}

