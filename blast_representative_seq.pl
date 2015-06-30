#! /usr/bin/perl

use strict;
use 5.010;
use Getopt::Long;

#######################################################################
my $blast2gi = "/home/sswang/tools/sequence_processing/blast2gi.sh";
my $get_fasta= "/mnt/bay3/sswang/tools_program/get_fasta.pl";
my $search_taxa_path = 	"/mnt/bay3/sswang/software/other/ncbi_taxonomy/search";
my $search_taxa_exe  =	"$search_taxa_path/search.pl.modified.pl";
my $search_taxa_db   =	"$search_taxa_path/taxa_info.db";

my ($blast_file, $step_print, $seq, $PNAS_list, $e_value, $rank, $cpu);

GetOptions(
	'blast_file|infile|in=s'	=>	\$blast_file,
	'step_print=s'			=>	\$step_print,
	'seq=s'				=>	\$seq,
	'PNAS_list=s'			=>	\$PNAS_list,
	'e_value=s'			=>	\$e_value,
	'taxa_level|rank=s'		=>	\$rank,
	'cpu=s'				=>	\$cpu,
) || die "illegal param!\n";

$cpu = 2 if not $cpu;

my $gi_all_list = "$blast_file" . ".gi.all.list";
my $seq_all_file= "$blast_file" . ".seq.all.fasta";
my $PNAS_list= "/home/sswang/huche/help/da_ding/process_wenjian/PNAS_list.taxaid-taxaname" if not $PNAS_list;
$step_print = 100 if not defined $step_print;

#######################################################################
if (not $seq){
	`\"$blast2gi\" \"$blast_file\" \"$gi_all_list\" $e_value`;
	#`awk '{print $2}' \"$blast_file\" | sed 's/gi|\([0-9]\+\).\+/\1/' > \"$gi_all_list\"`;
	`sort \"$gi_all_list\" | uniq | sponge \"$gi_all_list\"`;
	`\"$get_fasta\" -input \"$gi_all_list\" -output \"$seq_all_file\" -step_print \"$step_print\" -cpu $cpu`;
	print "\"$get_fasta\" -input \"$gi_all_list\" -output \"$seq_all_file\" -step_print \"$step_print\" -cpu $cpu" . "\n";
}
elsif(-e $seq){
	$seq_all_file = $seq;
}
else{
	die "seq file $seq cannot be opened!\n";
}

my $taxa_href = &get_PNAS_list($PNAS_list);
&output_seq($seq_all_file);


#######################################################################
sub output_seq{
my ($seq_all_file) = @_;
open (my $IN, '<', "$seq_all_file") || die;
open (my $OUT,'>', "$seq_all_file" . '.PNAS') || die;
	select $OUT;
my $k;
while(<$IN>){
	chomp;
	if (/^>gi\|(\d+) [^\[]+ \[(.+)\]/x){
		$k = 0;
		my $gi = $1;
		my $taxa_name = $2;
		my ($rank_name, $out);
		if (exists $taxa_href->{$taxa_name}){
			$k=1;
			if ($rank){
				$rank_name = `cd $search_taxa_path; perl search.pl.modified.pl "$taxa_name" taxa_info.db '' '' $rank`;
				chomp($rank_name);
				$out = $rank_name.'-' if $rank_name;
				#gi|50084246|ref|YP_045756.1| B12-dependent methionine synthase [Acinetobacter sp. ADP1]
			}
			chomp($rank_name);
			$taxa_name =~ s/_/__/g;
			$taxa_name =~ s/ /_/g;
			print ">" . $out . $taxa_name . "-". $gi . "\n";
		}
	}
	else{
		print "$_\n" if $k;
	}
}
select STDOUT;
close $IN; close $OUT;
}

sub get_PNAS_list{
	my %taxa;
	my ($PNAS_list) = @_;
	open (my $IN, '<', $PNAS_list) || die;
	while(<$IN>){
		chomp;
		next if /^\s*$/;
		my ($taxa_id, $taxa_name) = split /\t/;
		$taxa{$taxa_name} = 1;
	}
	close $IN;
	return (\%taxa);
}


