#! /usr/bin/perl

use 5.010;
use warnings;
use File::Basename;

&check_requirements();
$input_seq = &read_fasta();
$tmp_protein=&translation($input_seq);
$tmp_pep_aln=&align($tmp_protein);
&fasta_2_paml($tmp_pep_aln,$input_seq);
&clean();

####################################################################
####################################################################
sub check_requirements
{
	print STDERR "checking required programmes ......\n";
	for my $programme_name (qw(transeq muscle sort_fasta.pl pal2nal.pl)){
		`which $programme_name 2>/dev/null` or $programmes_not_found{$programme_name}=1;
	}
	if (keys %programmes_not_found != 0){
		print "5\n";
		foreach (keys %programmes_not_found){
			print "The programme ". $_. " is not found!\n";
		}
		print "existing ......\n";
		exit;
	}
}


sub read_fasta
{
	&show_help if scalar(@ARGV) < 1;
	my $input_seq=$ARGV[0];
	return($input_seq);
}

sub translation
{
	my ($seq)=@_;
	#system "transeq \"$seq\" tmp.pep";
	`transeq \"$seq\" tmp.pep`;
	#`sed -i '/^>/s/_[0-9]\+$//' tmp.pep`;
	return ('tmp.pep');
}

sub align
{
	my ($seq)=@_;
	`muscle -in $seq -out tmp.pep.aln`;
	return('tmp.pep.aln');
}

sub fasta_2_paml
{
	my ($tmp_pep_aln,$a)=@_;
	system "sort_fasta.pl \"$tmp_pep_aln\" > pep";
	system "sort_fasta.pl \"$a\" > nuc";
	&edit_fasta_headers();
	system "pal2nal.pl pep nuc -output paml";
}

sub clean{
	`rm nuc pep tmp.pep tmp.pep.aln`;
}

sub edit_fasta_headers{
    foreach my $file_name (qw(nuc pep)){
        open(IN, "<", $file_name);
	$content = do {local $/; <IN>};
        $content =~ s/(>[^\n]+)_\d+\n/$1\n/g;
	close IN;
	open(OUT,'>',$file_name);
	print OUT $content;
	close OUT;
    }
}

sub show_help{
	my $basename = basename($0);
	print "Usage: perl basename $basename input_seq\n";
	exit;
}


