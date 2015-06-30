#! /usr/bin/perl

use extract_gene;

my $infile = $ARGV[0];

$seq_href = &extract_gene::read_gene_seq($infile);

foreach (keys %$seq_href){
	my $seq=$seq_href->{$_}{'seq'};
	$seq =~ s/\-//g;
	my $length=length($seq);
	for ($length, $length-1, $length-2, $length-3){
		$_ % 3 == 0 and $substr = substr ($seq,0,$_);
	}
	print ">$_\n";
	$a=length($substr);
	#print $_."\n";
	#print $a."\n";
	print "$substr\n";
}


