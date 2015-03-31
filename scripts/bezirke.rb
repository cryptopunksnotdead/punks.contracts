# encoding: utf-8

require_relative 'common'


COUNTIES = read_counties()


i=0
COUNTIES.each_value do |c|
  i+=1
  if c.county_num != c.county_num2
    puts "#{c.county_num} != #{c.county_num2} in row #{i}: #{c.inspect}" 
  end
end

puts "#{i} records"


File.open( 'bezirke.txt', 'w' ) do |f|
  last_state = nil
  COUNTIES.each_value do |c|
    if last_state != c.state
      f.puts "#{c.state_num}   #{c.state}"
      last_state = c.state
    end
    f.puts "#{c.county_num2} .. #{c.county}"
  end
end
