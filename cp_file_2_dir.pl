#! /usr/bin/perl

use 5.010;
use warnings;

my ($input_dir,$new_dir,$ref_array);
my ($force_all,$force_dir,$force_file,$silent);
### force represents that to rebuild a DIR, whereas silent means putting file in the same dir withouting rebuilding a new empty DIR

($ref_array,$new_dir) = &read_parameter(@ARGV);

&create($ref_array,$new_dir);

#&copy_file_2_NewDir($ref_array,$new_dir);



################################################
################################################
sub read_parameter
{
my (@file,$new_dir);
my @para=@_;
foreach (@para){
        given ($_){
	when (/-file\=(.+)/)	{push @file,$_}
        when (/^\-new_dir\=(.+)/)       {$new_dir=$1}
	when (/^[^-]/) {push @file,$_}
        #########################
        when (/^\-\-?force_all/)    {$force_all='YES'}
	when (/^\-\-?force_file/)	{$force_file='YES'}
	when (/^\-\-?force_dir/)	{$force_dir='YES'}
	when (/^\-\-?silent/)	{$silent='YES'}
        }
        }
return (\@file,$new_dir);
}

sub create
{
my %hash;
my ($ref_array,$dir) = @_;
my @file=@{$ref_array};
my $return_value;
#print "@{$hash{'ref_array'}}\n";
DIR:{
	if (! -e $dir)	{system "mkdir -p \"$new_dir\"";}
	else	{&check('dir',$dir)}
}
FILE:{
	foreach my $file(@file){
	if (-e "$dir/$file") {$return_value=&check('file',"$dir/$file"); system "cp \"$file\" \"$dir\"" if $return_value eq 'OK'}
	if (! -e "$dir/$file")	{system "cp \"$file\" \"$dir\""}
	}
}
}


sub check
{
my ($type,$name)=@_;
my $return_value=0;
################################
################################
given ($type){
	when ('dir'){
		if (defined $force_dir or defined $force_all)	{&force_create_dir($name)}
		elsif (defined $silent)	{}
		else	{&ask_cover('dir',$name)}
		}
	when ('file'){
		if (defined $force_all or defined $force_file){
			$return_value='OK';
			}
		else{
		$return_value = &ask_cover('file',$name);
		}
	}
	}
return ($return_value);
}


sub ask_cover
{
my ($type,$name)=@_;
{	
	my $TYPE=uc($type);
	print "$TYPE ";
	system "print_color.pl $name 'bold red' -nohuiche";
	print " already exists\n";
	print "Would you like to cover the old one?\t";
	system "print_color.pl '[yes or no]?' 'bold green'";
	my $char=<STDIN>;
		if ($char =~ /^^y(es)?$/i){
			given ($type){
			when ('dir')	{&force_create_dir($name)}
			when ('file')	{return ('OK')}
			}
		}
       		else {return ('OK')}
           	#{$return_value='die'; die "cannot cover the old DIR\n";}
}
}


sub force_create_dir 
{
my ($dir)=@_;
system "rm -rf \"$dir\"; mkdir \"$dir\"";
}

sub copy_file_2_NewDir
{
my ($ref_array,$new_dir)=@_;
my @file=@{$ref_array};
system "cp @file \"$new_dir\"";
}






