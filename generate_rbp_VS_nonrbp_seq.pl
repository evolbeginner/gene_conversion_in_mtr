#! /usr/bin/perl

use 5.010;
my $fen_lei_seq_dir="./fen_lei_seq";

system "[ ! -s $fen_lei_seq_dir ] && mkdir -p $fen_lei_seq_dir";
foreach('non_rbp','S_rbp','L_rbp'){	open( $_, '>' , "$fen_lei_seq/$_");	}

$outdir = $fen_lei_seq_dir;
system "rm $outdir/*";

opendir (INDIR, "../../rbp/archaea_139_ENC/tmp/");
@dir = glob ("../../rbp/archaea_139_ENC/tmp/*tmp");

foreach my $dir (@dir){
	print STDOUT $dir."\n";
	open(IN,$dir);
	while(<IN>){
		chomp;
		if (/^>(.+)/){
			if (defined $seq){
				$seq{$outfile}{$count++}=">$seq_name\n$seq";
				#system "echo \"$seq_name\n$seq\n\" >> \"$outdir/$outfile\"";
			}
			$seq='';
			($seq_name = $1) =~ s/ /_/g;
			$outfile = &test_rbp($seq_name);
		}
		else{
			$seq.=$_;
		}
	}
	close IN;
}


foreach my $key1 (keys %seq){
	print $key1."\n";
	open(my $OUT, '>' , "$outdir/$key1");
	foreach $key2 (keys %{$seq{$key1}}){
		print $OUT "$seq{$key1}{$key2}\n";
	}
	close $OUT;
}


#############################################################
sub test_rbp{
my ($input)=@_;
my $return;
given ($input){
	when (/ribosomal_pro/i){
		given ($input){
			when (/methyl/)	{}
			when (/ase/)	{}
			#when (/protein_([LS])\d+/i){my $a=uc($1); $return=$a.'_rbp';}
			when (/^(\d+)S[^\d]+(\d+).?$/i){
				$return="$2_S_rbp" if $1 == 30;
				$return="$2_L_rbp" if $1 == 50;
			}
		}
	}
	default {$return='non_rbp'}
}
$return = do {defined $return ? $return : 'non_rbp'};
return($return);
}



