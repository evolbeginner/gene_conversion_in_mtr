#! /usr/bin/perl
use 5.010;
use Bio::SeqIO;
use File::Basename;
use Getopt::Long;
use strict;

my $old_locus_tag=1;
my ($dir, $filter_conf, $XiangDui_strand_swi, $print_out, @print_out);
my (%taxa, %uid, %filter, @key_print);

GetOptions(
	'dir=s'			=>	\$dir,
	'filter_conf=s'		=>	\$filter_conf,
	'print_out=s'		=>	\$print_out,
	'XiangDui_strand!'	=>	\$XiangDui_strand_swi,
) or die "illegal params";

&check_param();
@print_out = &get_key_print($print_out);


<<__help__
1	NC_002754.1     RefSeq  gene    2868858 2869754 .       +       .       ID=gene2909;Name=SSO3118;Dbxref=GeneID:1453140;gbkey=Gene;locus_tag=SSO3118
2	NC_002754.1     RefSeq  CDS     2868858 2869754 .       +       0       ID=cds2855;Name=NP_344431.1;Parent=gene2909;Note=COG0179: 2-keto-4-pentenoate hydratase%2F2-oxohepta-3-ene-1%2C7-dioic acid hydratase;Dbxref=Genbank:NP_344431.1,GeneID:1453140;gbkey=CDS;product=hypothetical protein;protein_id=NP_344431.1;transl_table=11
3	gi|158333233|ref|NC_009925.1|:c6503480-6502701 Acaryochloris marina MBIC11017 chromosome, complete genome
__help__
;

foreach my $indir (glob "$dir/gff/*"){
	my ($taxa_k, @ordered_gff_info);
	my ($core_infile,$taxa_uid,$taxa,$uid);
	my ($ref_gff);
	chomp ($indir);
	($taxa_uid) = $indir =~ /\/?([^\/]+)$/;
	($taxa,$uid) = $taxa_uid =~ /(.+)_uid(\d+)/;
	$taxa{$core_infile}=$taxa;
	$uid{$core_infile}=$uid;	
	my @infile= glob "$indir/*";

	foreach (keys %{$filter{'taxa'}}){
		++$taxa_k and last if $taxa_uid =~ /$_/;
	}
	next if not $taxa_k;

	&extract_seq($dir,$taxa_uid,'faa');
	#&extract_seq($dir,$taxa_uid,'ffn');

	my $ref_gff_tmp = &extract_gff(\@infile,$taxa_uid);

	for my $genome_ACCN (keys %$ref_gff_tmp){
		my $ref_gff = $ref_gff_tmp->{$genome_ACCN};
		@ordered_gff_info = sort {$ref_gff->{$a}{'start'} <=> $ref_gff->{$b}{'start'}} keys %$ref_gff;
		foreach my $num (0..$#ordered_gff_info){
			my ($filter_ACCN_k, $ref1, $key1, @jie_qu_updown_stream_gene_num);
			$key1 = $ordered_gff_info[$num];
			$ref1 = $ref_gff->{$key1};
			foreach (keys %{$filter{'ACCN'}}){
				++$filter_ACCN_k and last if exists $filter{'ACCN'}{$ref1->{'protein_id'}};
			}
			next if not $filter_ACCN_k;
			#print '***'."\t".$taxa_uid."\t".$ref1->{'product'}."\t".$ref1->{'protein_id'}."\n";
			print join ("\t", $taxa_uid, $ref1->{'product'}, $ref1->{'protein_id'})."\t";
			@jie_qu_updown_stream_gene_num = ($num-4..$num+4);
			if ($ref_gff->{$key1}{'strand'} eq '-'){
				@jie_qu_updown_stream_gene_num = reverse @jie_qu_updown_stream_gene_num;
			}
			foreach (@jie_qu_updown_stream_gene_num){
				my $key = $ordered_gff_info[$_];
				foreach (@print_out){
					my $XiangDui_strand;
					if ($XiangDui_strand_swi){
						$XiangDui_strand = &XiangDui_strand($ref_gff->{$key}{'strand'}, 
							$ref_gff->{$ordered_gff_info[$num]}{'strand'});
						print $ref_gff->{$key}{$_};
						print " $ref_gff->{$key}{'protein_id'} $XiangDui_strand"."\t";
					}
					else{
						print $ref_gff->{$key}{$_}."\t";					
					}
				}
			}
			print "\n";
		}
	}
}


##################################################################
##################################################################
sub read_fasta{
<<Note
	不是标准的read_fasta since the name of SEQ is changed
Note
;
	my ($catchseq_seqio_obj, %seq_ffn);
	my ($input_seq,$type) = @_;
	my (%seq_faa,$seq_ffn);
	$catchseq_seqio_obj = Bio::SeqIO->new(-file=>$input_seq, -format=>'fasta');
	while(my $seq_obj=$catchseq_seqio_obj->next_seq()){
		my ($name, $seq, $full_name, $ACCN, $GI, $posi);
		$full_name = $seq_obj->display_name;
		($ACCN) = $full_name =~ /(?:[^\|]+\|){3}([^\|]+)\|/;
		($GI) = $full_name =~ /gi\|(\d+)\|/;
		($posi) = $full_name =~ /(?:[^\|]+\|){4}\:(c?\d+\-\d+)/;
		$ACCN =~ s/\..+$//;
		given ($type){
			when('faa'){
				$seq_faa{$ACCN}{'GI'}  = $GI;
				$seq_faa{$ACCN}{'seq'} = $seq_obj->seq;
			}
			when('ffn'){
				$seq_ffn{$ACCN."\|$posi"}{'seq'} = $seq_obj->seq;
			}
		}
	}
	return (\%seq_faa) if $type eq 'faa';
	return (\%seq_ffn) if $type eq 'ffn';
}


sub extract_seq{
	my ($dirname, @haha);
	my ($dirname,$taxa_uid,$type) = @_;
	@haha = glob "$dirname/$type/$taxa_uid/*";
	#print "$dirname/$type/$taxa_uid"."\n";
	#print $taxa_uid."\n";
	foreach my $infile(@haha){
		my $ref_seq=&read_fasta("$infile",$type);
		foreach (keys %$ref_seq){
			my $ref=$ref_seq->{$_};
			#print '>'.$_."\n".$ref->{'seq'}."\n";
		}
	}
}


sub extract_gff{
my (%gff, $info);
my ($ref, $taxa_uid) = @_;
foreach my $infile(@$ref){
	my ($property, $start, $end, $strand, $locus_tag, $posi, $return_key, 
		 $info, $COG, $protein_id, $product, $description);
	my ($core_infile);
	my @array_name=qw(COG product protein_id start end strand);
	($core_infile) = $infile =~ /\/?([^\/\.]+)[^\/]*$/;
	#$p = `find ./all/fna/$taxa_uid` or print fail."\n";
	open (my $IN_handle, '<', $infile) || die "infile cannot be opened\n";
	while(my $line=<$IN_handle>){
		chomp($line);
		my (@p, $info);
		next if $line !~ /^NC_/;
		@p = (split /\t/,$line)[2,3,4,6,8];
		($property,$start,$end,$strand,$description) = @p;
		given ($property){
			when($_ eq 'gene')	{($locus_tag) = &parse_gene(\@p);}
			when($_ eq 'CDS')	{($COG,$product,$protein_id) = &parse_CDS(\@p);}
		}
		if ($property eq 'CDS'){
			$locus_tag eq $old_locus_tag ? 1 : do {
				$info = $taxa_uid."\t".$locus_tag."\t".join("\t",$COG,$product,$protein_id,$start,$end,$strand);
			};
			$old_locus_tag=$locus_tag;
		
		$posi = $start < $end ? $start.'_'.$end : 'c'.$end.'_'.$start;
		$return_key = $core_infile.'|'.$posi;

		$gff{$core_infile}{$return_key}{'COG'}		=	$COG;
		$gff{$core_infile}{$return_key}{'product'}	=	$product;
		$gff{$core_infile}{$return_key}{'protein_id'}	=	$protein_id;
		$gff{$core_infile}{$return_key}{'start'}	=	$start;
		$gff{$core_infile}{$return_key}{'end'}		=	$end;
		$gff{$core_infile}{$return_key}{'strand'}	=	$strand;
		$gff{$core_infile}{$return_key}{'info'}		=	$info;
		}
	}
	close IN;
}
return (\%gff);
}

sub parse_CDS{
	my ($COG,$product,$protein_id);
	my ($ref)=@_;
	($COG) = $ref->[4] =~ /Note\=(COG\d+)/i;
	($product) = $ref->[4] =~ /product\=([^\;]+)/;
		$product =~ s/\%..//g;
	($protein_id) = $ref->[4] =~ /protein_id=(\w+_\d+)/;
	#print $protein_id."\n";
	return ($COG,$product,$protein_id);
}

sub parse_gene{
	my ($ref)=@_;
	my ($locus_tag);
	($locus_tag) = $ref->[4] =~ /locus_tag=(.+)$/;
	return ($locus_tag);
}

sub get_key_print{
	my @print_out;
	my ($print_out) = @_;
	$print_out = 'info' if not $print_out;
	@print_out = split /\,/, $print_out;
	return (@print_out);
}

sub XiangDui_strand{
	my ($XiangDui_strand);
	my ($strand1, $focused_gene_strand) = @_;
	if ($strand1 eq $focused_gene_strand){
		$XiangDui_strand='+' x 5; 
	}
	else{
		$XiangDui_strand='-' x 5;
	}
	return ($XiangDui_strand);
}

####################################################################
sub check_param{
	$dir="/mnt/bay3/sswang/NCBI_ftp_download/NCBI_ftp_bacterial_genome/parse_NCBI_ref_genome/all" if not $dir;
	open (my $IN, '<', "$filter_conf") || die "filter_conf cannot be opened";
	while(<$IN>){
		chomp;
		my ($ACCN, $taxa) = split /\t/;
		$filter{'ACCN'}{$ACCN} = 1;
		$filter{'taxa'}{$taxa} = 1;
	}
}


