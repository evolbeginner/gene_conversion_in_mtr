#! /usr/bin/perl

open (my $IN, '<', $ARGV[0]);
while(<$IN>){
	chomp;
	$_ =~ s/(?<=[(,])([^:,()]+)(?=\:)/&change_OTU_name($1)/ge;
	print $_."\n";
}

sub change_OTU_name{
	my (@new_name, $ACCN, @a);
	my ($OTU_name) = @_;
	#@new_name = $OTU_name =~ /\-([^-]+)(?:(?:\-.+(\.\.\.\d+))|(?:\-.+))/;
=cut
	print $OTU_name."\n";
	$OTU_name =~ s/^(.) [^_]+ (_) (.{1,3}) .*? (\d+)$/$1$2$3-$4/x;;
	return ($OTU_name);
=cut
	#@new_name = $OTU_name =~ /\-([^-]+)(?:(?:\_.+(\.\.\.\d+))|(?:\_.+))/;
    $OTU_name =~ s/[-]\.\.\.\d+//;
	@a = $OTU_name =~ /(?:[^-]+\-)? ([^-]+) [-]/x;
	#($ACCN) = $OTU_name =~ /([ZWNY]P_\d+(\.\d)?)/;
	($ACCN) = $OTU_name =~ /([^-]+)$/;
	#@a=grep {defined} @new_name;
	#map {$_ =~ s/\.\.\.//;} @a;
	#map {$_ =~ s/^(.) [^_]+ (_) (.{1,3}) .* (\d+)$/$1$2$3$4/x;} @a;
	@a[0..1] = ($a[0],$ACCN);
	return (join '-',@a);
}

