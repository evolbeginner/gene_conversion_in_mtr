#! /usr/bin/perl
######################################

use 5.010;
use strict;
use extract_gene;
use Cwd;
use Getopt::Long;

my ($infile, $tmpred_path);
my ($TMP_DIR, $cwd);
my ($tmpred_exe, $tmpred_matrix_tab);
my (%gene, $gene_href, %trans_posi);

GetOptions(
	'in=s'		=>	\$infile,
	'tmpred_path'	=>	\$tmpred_path,
) || die "param error!\n";

$tmpred_path = "/home/sswang/software/sequence_analysis/TMpred-1.1" if not $tmpred_path;
$tmpred_exe = "$tmpred_path/tmpred";
$tmpred_matrix_tab = "$tmpred_path/matrix.tab";
$cwd = cwd($0);
$TMP_DIR = "$cwd/tmp_TMpred";
	`rm -rf $TMP_DIR` if -e $TMP_DIR;
	`mkdir -p $TMP_DIR`;

###############################################################################

$gene_href = &extract_gene::read_gene_seq($infile);
	%gene = %$gene_href;

foreach (keys %gene){
	my ($name);
	open (my $OUT, '>', "$TMP_DIR/infile") || die;
	print $OUT ">".$_."\n".$gene{$_}{'seq'}."\n";
	$name = $_;
	system "cd $tmpred_path;
		$tmpred_exe -in=\"$TMP_DIR/infile\" -out=\"$TMP_DIR/tmpred.out\" -min=17 -max=33 -par=matrix.tab -def";
	#print "$tmpred_exe -in=lala.fa -out=lala.out -min=17 -max=33 -par=$tmpred_matrix_tab -def\n";

	print $name."\t";
	open (my $IN, '<', "$TMP_DIR/tmpred.out") || die;
	lala:	while(<$IN>){
		if (/^-----> STRONGLY prefered model/){
			<$IN>; <$IN>;
			while(<$IN>){
				last lala if /^\s*$/;
				my ($start, $end) = (split)[1,2];
				print $start.'-'.$end."\t";
				#$trans_posi{$name}{$start.'-'.$end} = 1;
			}
		}
	}
	print "\n";
	close $OUT;
}

exit;
foreach my $key1 (keys %trans_posi){
	print $key1."\t";
	foreach my $key2 (keys %{$trans_posi{$key1}}){
		print "$key2\t";
	}
	print "\n";
}



