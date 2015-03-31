
require_relative 'common'


COUNTIES = read_counties()
MUNIS    = read_munis()



###########
# check if muni_num are equal
#  -- must hold (assert true); only for special case Wien not true

i=0
MUNIS.each_value do |m|
  ## pp row if i % 10 == 0
  i+=1

  if m.muni_num != m.muni_num2
    puts "#{m.muni_num} != #{m.muni_num2} in row #{i}: #{m.inspect}" 
  end
end

puts "#{i} records"


File.open( 'gemeinden.txt', 'w' ) do |f|
  last_state  = nil
  last_county = nil

  MUNIS.each_value do |m|

    ## calculate county_num from muni_num (use first three digits)
    county_num2 = m.muni_num2[0..2]
    c = COUNTIES[ county_num2 ]
    if c.nil?
      puts "** err: no county found for #{m.inspect}"
    end
  
    if last_state != c.state
      f.puts "#{c.state_num}     #{c.state}"
      last_state = c.state
    end
  
    if last_county != c.county
      f.puts "#{c.county_num2}   .. #{c.county}"
      last_county = c.county
    end  

   ## note: %-40s cannot handle non-ascii!!!! (on windows)
   ##   will add one extra space for umlaut e.g. äöüß etc. 
    f.puts "#{m.muni_num2} .... #{'%-37s' % m.muni}  ## #{'%-2s; %-4s; %s' % [m.muni_kind,m.muni_postalcode,m.muni_postalcodes_more]}"
  end
end

