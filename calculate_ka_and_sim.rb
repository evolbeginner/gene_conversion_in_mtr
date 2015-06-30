#! ruby

total = 0
counter=0

values = Array.new

File.open(ARGV[0], 'r').each_line do |line|
  line.chomp!
  line.split.each_with_index do |ele, index|
    #next if (index-$.)%2 != 0
    #if index != line.split.size-1 or $.%2 == 0
    if index != 0 or $.%2 == 0
      next
    end
    ele = ele.to_f
    total+=ele
    counter+=1
    values << ele
  end
end

#puts total/counter
puts values

