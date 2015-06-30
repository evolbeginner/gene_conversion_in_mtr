#! /usr/bin/perl
use 5.010;
use warnings;

my @parameter=&read_parameter(@ARGV);
my (%seq,$ref_seq,$line1);
### i.e. @parametr:($input_seq,$osformay)
@parameter=&check_parameter(@parameter);

my ($input_seq,$osformat,$region) = @parameter; # purely defined parameters
($ref_seq,$line1) = &read_input_seq($input_seq); # just read input_seq

$ref_seq = &modify_seq($ref_seq,$region) if defined $region;

&Shu_Chu($ref_seq,$line1);



#######################################################################
#######################################################################
sub read_parameter
{
my @a=@_;
my ($input_seq,$osformat);
foreach (@a)
{
	given($_){
	when (/^\-osformat\=(.+)/)	{$osformat=$1}
	when (/^\-in\=(.+)/)	{$input_seq=$1}
	when (/^\-region\=(.+)/)	{$region=$1}
	}
}
return($input_seq,$osformat,$region);
}

sub check_parameter
{
my ($input_seq,$osformat,$region)=@_;
open (my $IN, $input_seq) or die "cannot open input_seq\n";
{
	if (defined $osformat){
		die "osformat is not correct\n" if $osformat ne 'fasta';
		}
	else {$osformat='fasta'}
}
return($input_seq,$osformat,$region);
}


sub read_input_seq
{
my ($input_seq)=@_;
open(IN,$input_seq);
$line1=<IN>;
chomp ($line1);
my %seq;
my ($seq_num,$num_char) = $line1 =~ m/(\d+)\s+(\d+)/; # i.e.  2  531
my ($count_line,$add,$num_line_per_seq) = (0,0,0);

$num_char%60 ? ($add=1) : ($add=0);
$num_line_per_seq=int($num_char/60)+1+$add;
while($line=<IN>){
	chomp($line);
	++$count_line;
	($count_line % $num_line_per_seq == 1) ? ($seq_name=$line) : ($seq{$seq_name}.=$line);
	}
close IN;
return (\%seq,$line1);
}


sub Shu_Chu
{
my ($ref_seq,$line1)=@_;
%seq=%{$ref_seq};
print $line1."\n";
foreach (keys %seq)	{print ">$_"."\n".$seq{$_}."\n"}
}


sub modify_seq
{
my ($ref_seq,$region)=@_;
my %seq=%{$ref_seq};
@region=split /\-/,$region;
my ($start,$end) = @region;
print $start."\t".$end."\n";
foreach (keys %seq){
	$seq{$_}=substr ($seq{$_},$start,$end);
	}
return (\%seq);
}




