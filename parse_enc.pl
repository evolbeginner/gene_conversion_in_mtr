#! /usr/bin/perl
use 5.010;

my ($ref_core_ACCN,$swi_taxa_name);
my @output = qw(non_rbp L_rbp S_rbp);
foreach (@output){system "[[ -e $_ ]] && rm $_";}

my $ENC_dir="/home/sswang/huche/archaea_GC/rbp/archaea_139_ENC/*enc";


$ref_core_ACCN = &read_ACCN_taxa("./ACCN_taxaname");

@ENC_file=glob "$ENC_dir";
foreach (@ENC_file){
	chomp;
	&parse($_);
}


#######################
sub parse
{
my ($input)=@_;
open (IN,'<',$input);
my $core_name=&core_name($input);	
while(<IN>){
	chomp;
	my ($test_rbp,$output_file);
	my @a=split;
	next if $a[1] !~ /\d/;
	$test_rbp=&test_rbp($a[0]);
	$output_file = &output_file($test_rbp);
	my $output = $test_rbp."\t".join ("\t",$a[1],$a[2],$a[3]);
	system "echo -e \"$output\t$core_name\t$ref_core_ACCN->{$core_name}\" >> \"$output_file\"";
	#system "echo -e \"$output\t$core_name\t\" >> \"$output_file\"";
}
close IN;
}


sub test_rbp{
my ($input)=@_;
my $return;
given ($input){
	when (/ribosomal_pro/i){
		given ($input){
			when (/methyl/)	{}
			when (/ase/)	{}
			when (/protein_([LS])\d+/i)	{my $a=uc($1); $return=$a.'_rbp';}
			when (/^(\d+)S/i){
				$return='S_rbp' if $1 == 30;
				$return='L_rbp' if $1 == 50;
			}
		}
	}
	default {$return='non_rbp'}
}
$return = do {defined $return ? $return : 'non_rbp'};
return($return);
}


sub output_file{
my $return;
my ($in)=@_;
given ($in){
	when ('non_rbp') {$return=$in}
	when ('L_rbp')	{$return=$in}
	when ('S_rbp')	{$return=$in}
}
return ($return);
}

sub core_name{
	my ($input)=@_;
	my $core_name;
	($core_name) = `basename $input` =~ /([^\.]+)/;
	print $core_name."\n";
	return ($core_name);
}

sub taxa_name{
	my ($core_name)=@_;
	split
	return ($taxa_name);
}

sub read_ACCN_taxa{
	my ($ACCN_taxaname)=@_;
	print $ACCN_taxaname."\n";
	system "cut -f1,2 \"$ACCN_taxaname\" > tmp_lala";
	open (IN,'<',"tmp_lala");
	while(<IN>){
		chomp;
		my @line=split /\t/,$_;
		$core_ACCN{$line[0]}=$line[1];
	}
	close IN;
	system "rm tmp_lala";
	print "\n\treading of ACCN_taxaname has been finished\n\n\n";
	return (\%core_ACCN);
}





