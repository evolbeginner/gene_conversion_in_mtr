#! /bin/env ruby

require 'getoptlong'

geo_info_file="/mnt/bay3/sswang/NCBI_ftp_download/NCBI_ftp_bacterial_genome/RNA/orgn_info"
search_taxa_info="/mnt/bay3/sswang/software/other/ncbi_taxonomy/search/search_taxa_info.pl"
taxa_list_file=nil
is_hyphen=FALSE
is_genus=FALSE
is_no_str=TRUE

###########################################################################################
class TaxaList
  attr_accessor :taxa, :geo_info, :original_name
  def initialize(taxa_list_file,geo_info_file)
    @taxa_list_file=taxa_list_file
    @geo_info_file=geo_info_file
    @taxa={}
    @geo_info={}
    @original_name={}
  end
  def get_taxa(is_hyphen, is_no_str)
    fh=File.open(@taxa_list_file, 'r')
    while(line=fh.gets) do 
      line.chomp!
      original=line.dup
      line.gsub!(/[ -]/,"_") if is_hyphen
      line.gsub!(/[ _]str\./,"") if is_no_str
      @taxa[line]=1
      @original_name[line]=original
    end
    fh.close
  end
  def get_geo_info()
    fh=File.open(@geo_info_file, 'r')
    while(line=fh.gets) do
      line.chomp!
      taxa_name, geo_info_content = line.split("\t",2)
      geo_info[taxa_name]=geo_info_content
    end
    fh.close
  end
end

###########################################################################################
opts = GetoptLong.new(
  ['--taxa_list','--taxa_list_file', GetoptLong::REQUIRED_ARGUMENT],
  ['--geo_info_file', GetoptLong::REQUIRED_ARGUMENT],
  ['--search_taxa_info', GetoptLong::REQUIRED_ARGUMENT],
  ['--hyphen', '--is_hyphen', GetoptLong::NO_ARGUMENT],
  ['--genus', '--is_genus', GetoptLong::NO_ARGUMENT],
  ['--no_str', '--is_no_str', GetoptLong::NO_ARGUMENT],
)

opts.each do |opt,value|
  case opt
    when '--taxa_list','--taxa_list_file'
      taxa_list_file=value
    when '--geo_info_file'
      geo_info_file=value
    when '--search_taxa_info'
      search_taxa_info=value
    when '--hyphen', '--is_hyphen'
      is_hyphen=TRUE
    when '--genus', '--is_genus'
      is_genus=TRUE
    when '--no_str', '--is_no_str'
      is_no_str=TRUE
  end
end

###########################################################################################
taxa_list_obj = TaxaList.new(taxa_list_file, geo_info_file)
taxa_list_obj.get_taxa(is_hyphen, is_no_str)
taxa_list_obj.get_geo_info()

taxa_list_obj.taxa.each_pair do |k, v|
  genus_name=k.split(/[-_ ]+/)[0]
  search_key = is_genus ? genus_name : k
  f=open("| perl \"#{search_taxa_info}\" --taxa \"#{search_key}\" --rank order --concise")
  print taxa_list_obj.original_name[k]+"\t"
  print f.read.split(/\t/)[1]+"\t"
  puts taxa_list_obj.geo_info[k]
end


