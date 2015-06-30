#! /bin/env ruby

require 'getoptlong'

infile=nil
p_value_order=nil

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--infile', '--in', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--p_value', '-p', GetoptLong::REQUIRED_ARGUMENT ],
)

######################################################
opts.each do |opt, arg|
  case opt
    when '-h', '--help'
      show_Help()
    when '--infile', '--in'
      infile=arg
    when '--p_value', '-p'
      p_value_order=arg.to_i
  end
end

######################################################
fh = File.open(infile ,'r')
while(line=fh.gets) do
  if line =~ /^GI [\s]+ ([^; ]+) \; ([^; ]+) \s+ (.+)/x
    seq_name_1, seq_name_2, values, p_value_1, p_value_2 = nil
    p_values = []
    seq_name_1=$1
    seq_name_2=$2
    values=$3
    taxon_name_1 = seq_name_1.split('-')[1]
    taxon_name_2 = seq_name_2.split('-')[1]
    next if taxon_name_1 != taxon_name_2
    #p_values = (values.split(/\s+/)).values_at(0,1)
    p_values = (values.split(/\s+/))
    print taxon_name_1 + "\t" + p_values.join("\t")
    puts
  end
end


