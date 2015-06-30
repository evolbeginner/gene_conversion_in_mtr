#! /usr/bin/perl

$newick_file=$ARGV[0];
$max_bootstrap=do {defined $ARGV[1] ? $ARGV[1] : 100};

( @ARGV < 1 ) and die "The number of PARAM is less than 1.";

$Chu_Shu=$max_bootstrap/100;

open (my $IN, '<', "$newick_file");
while(<$IN>){
	next if $_ !~ /\w/;
	$_ =~ s/(?<=\))([0-9]+(\.\d+)?)/{int($1\/$Chu_Shu+0.5)}/eg;
	print;
}


