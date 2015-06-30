#! /bin/env/ ruby

require 'getoptlong'

infile = nil
is_no_geneconv = FALSE
is_modify_seq_title = FALSE

###############################################################
opts = GetoptLong.new(
  [ '--infile', '--in', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--no_geneconv', GetoptLong::NO_ARGUMENT ],
  [ '--modify_seq_title', GetoptLong::NO_ARGUMENT ],
)

opts.each do |opt, arg|
  case opt
    when '--infile', '--in'
      infile = arg
    when '--no_geneconv'
      is_no_geneconv = TRUE
    when '--modify_seq_title'
      is_modify_seq_title = TRUE
  end
end

################################################################
fh = File.open(infile, 'r')
while(line=fh.gets()) do
  line=line.chomp
  seq_names = []
  next if not line =~ /\,|^\s+\d+/
  line_array = line.split(/[,]/)
  seq_names = line_array.values_at(8,9,10)
  next if seq_names[0] !~ /\w/ or line_array[11] !~ /\w/
  if seq_names[0] == seq_names[1] or seq_names[0] == seq_names[2]
    if is_modify_seq_title
      seq_names.map!{|i| i=~/[^-]+[-]([^-]+)/; $1}
    end
    print seq_names[0] + "\t"
    print_out_line_array=[]
    print_out_line_array = is_no_geneconv ? [line_array[11]].concat(line_array[13,100]) : line_array[11,100]
    print_out_line_array.each{|e| (e !~ /NS/) ? (printf "%g\t" % e.strip.to_f) : (print "NS\t");}
    puts
  end
end

