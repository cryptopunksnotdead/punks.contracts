
require_relative 'common'


COUNTIES = read_counties()
MUNIS    = read_munis()
LOCS     = read_locs()


File.open( 'orte.txt', 'w' ) do |f|
  last_state  = nil
  last_county = nil
  last_muni   = nil

  LOCS.each_value do |l|

    ## calculate county_num from muni_num (use first three digits)
    m = MUNIS[ l.muni_num ]
    if m.nil?
      puts "** err: no municipality found for #{l.inspect}"
      #code
    end

    county_num = l.muni_num[0..2]
    c = COUNTIES[ county_num ]
    if c.nil?
      puts "** err: no county found for #{l.inspect}"
    end
  
    if last_state != c.state
      f.puts "#{c.state_num}     #{c.state}"
      last_state = c.state
    end
  
    if last_county != c.county
      f.puts "#{c.county_num2}   .. #{c.county}"
      last_county = c.county
    end  

   if last_muni != m.muni
     ## note: %-40s cannot handle non-ascii!!!! (on windows)
     ##   will add one extra space for umlaut e.g. äöüß etc. 
     f.puts "#{m.muni_num2} .... #{'%-37s' % m.muni}  ## #{'%-2s; %-4s; %s' % [m.muni_kind,m.muni_postalcode,m.muni_postalcodes_more]}"
     last_muni = m.muni
   end

   f.puts "#{l.loc_num} ...... #{'%-35s' % l.loc}  ## #{l.loc_postalcodes}"
  end
end
