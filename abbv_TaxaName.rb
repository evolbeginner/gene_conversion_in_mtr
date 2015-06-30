#! /bin/env ruby


require 'getoptlong'

infile=nil
format=nil
is_subspecies=FALSE

############################################
def abbv_taxa_name(taxa_name, format, is_subspecies, separator=',')
  num_of_G, num_of_S = format.split(separator)
  taxa_abbr=taxa_name.sub(%r{^(\w{#{num_of_G}})\S+ (\S{1,#{num_of_S}})\S*\s?(.+)}) do |x|
    if is_subspecies then
      $1+$2+'-'+$3
    else
      $1+$2
    end
  end
  return(taxa_abbr)
end

############################################
opts = GetoptLong.new(
  ['--in', '-i', GetoptLong::REQUIRED_ARGUMENT],
  ['--format', GetoptLong::REQUIRED_ARGUMENT],
  ['--subspecies', GetoptLong::NO_ARGUMENT],
)

opts.each do |opt,value|
  case opt
    when '--in', '-i'
      infile=value
    when '--format'
      format=value
      raise "format is incorrect" if format !~ /^\d\,\d+$/
    when '--subspecies'
      is_subspecies=TRUE
  end
end

############################################
fh=File.open(infile,'r')
while(line=fh.gets) do
  line.chomp!
  print line+"\t"+abbv_taxa_name(line, format, is_subspecies)+"\n"
end

