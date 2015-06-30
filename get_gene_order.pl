#! /usr/bin/perl

use 5.010;
use strict;
use Getopt::Long;

my ($aln_file, $conf_file, $seq_href);

GetOptions(
	'aln_file=s'	=>	\$aln_file,
	'conf_file=s'	=>	\$conf_file,
);

$aln_file="/home/sswang/huche/archaea_GC/mtr_seq/aln/aln_fasta/mtrA_NPYP.aln" if not $aln_file;
$conf_file="./filter.conf" if not $conf_file;

$seq_href = &read_aln_file($aln_file);
&create_conf_file($conf_file, $seq_href);

#########################################################################
sub read_aln_file{
	my (%seq);
	my ($aln_file) = @_;
	open (my $IN, '<', $aln_file) || die "duplicate file cannot be opened";
	while(<$IN>){
		chomp;
		#next unless /^>(?:[^-_]+\-)? ([^-_]+_[^-_]+) .+\- ([NYZ]P_\d+)/x;
		next unless /^>(?:[^-_]+\-)? ([^-_]+) .+\- ([NYZ]P_\d+)/x;
		$seq{$2}=$1;
	}
	return (\%seq);
}

sub create_conf_file{
	my ($conf_file, $seq_href) = @_;
	open (my $OUT, '>', "$conf_file") || die "conf file cannot be created";
	foreach my $key (sort keys %$seq_href){
		print $OUT "$key"."\t"."$seq_href->{$key}\n";
	}
}


