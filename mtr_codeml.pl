#! /usr/bin/perl
use 5.010;
use warnings;
($model=0,$NSsites='0,1,2,3',$ncatG=3);
my @file;
my $dir="/home/sswang/huche/archaea_GC/archaea_NCBI_ftp_gff/result_extract_speci";
## this could be replaced by ARGV
my $parent_dir="";


@file=&get_file($dir);

foreach my $file(@file){
	my $parent_dir='/home/sswang/huche/archaea_GC/archaea_NCBI_ftp_gff/result_extract_speci/codeml_paml';

	($core_name)=&core_name_file($file);
	print $core_name."\n";
	#run_cp_file_2_dir("echo 5")
	system "cp_file_2_dir.pl -seqfile=\"$file\" -new_dir=\"$parent_dir/$core_name\"";	
	#run_cp_file_2_dir("echo 5")
	}

exit;

&run_cp_file_2_dir();
&run_create_codemlctl();


###################################
###################################
###################################
sub get_file
{
my ($dir)=@_;
my @file=glob "$dir/mtr[D]*"; # note mtrD
return (@file);
}

sub core_name_file
{
my ($file_name)=@_;
($core_name) = $file_name =~ /([^\/\.]+) \. [^\/\.]*$/x;

}

sub run_cp_file_2_dir
{
	my ($a)=@_;
	system "\"$a\"";
}

sub run_create_codemlctl 
{
($model,)=@_;
system "create_codemlctl.pl -model=\"$model\" -NSsites=\"$NSsites\" -seqfile=\"$seqfile\" -treefile=\"$treefile\" -outfile=\"$outfile\" -ncatG=\"$ncatG\" -seqtype=\"$seqtype\" -output_codemlctl_dir=\"$output_codemlctl_dir\"";


}





