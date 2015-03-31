# encoding: utf-8


require 'csv'
require 'pp'


## :skip_lines
## When set to an object responding to match, every line matching
## it is considered a comment and ignored during parsing. When set to a String, it is first converted to a Regexp. When set to nil no line is considered a comment.
## If the passed object does not respond to match, ArgumentError is thrown.
##  check if available in csv

CSV_OPTS = { col_sep: ';',
             skip_blanks: true,
             skip_lines: /^[ ]*\#{1,}/ }



##############
# read in all counties into a hash
#
# Fields:
#  1) Bundeslandkennziffer
#  2) Bundesland
#  3) Kennziffer pol. Bezirk
#  4) Politischer Bezirk
#  5) Politischer Bez. Code

County = Struct.new( :state_num,
                     :state,
                     :county_num,
                     :county,
                     :county_num2 )

def read_counties
  hash = {}
  CSV.foreach( 'dl/bezirke.csv', CSV_OPTS ) do |row|
    c = County.new( row[0], row[1], row[2], row[3], row[4] )
    hash[ c.county_num2 ] = c
  end
  hash
end


##############################
# read in all muni(cipalities) into a hash
#
#  Fields:
#   1) Gemeindekennziffer
#   2) Gemeindename
#   3) Gemeindecode
#   4) Status
#   5) PLZ des Gem.Amtes
#   6) weitere Postleitzahlen

Muni = Struct.new( :muni_num,
                   :muni,
                   :muni_num2,
                   :muni_kind,
                   :muni_postalcode,
                   :muni_postalcodes_more )

def read_munis
  hash = {}
  CSV.foreach( 'dl/gemeinden.csv', CSV_OPTS ) do |row|
    m = Muni.new( row[0], row[1], row[2], row[3], row[4], row[5] )
    hash[ m.muni_num2 ] = m
  end
  hash
end


####################################
# read in all localities - cities/towns/villages/hamlets into a hash
#
#  Fields:
#   1) Gemeindekennziffer
#   2) Gemeindename
#   3) Ortschaftkennziffer
#   4) Ortschaftsname
#   5) Postleitzahl

Loc = Struct.new( :muni_num,
                  :muni,
                  :loc_num,
                  :loc,
                  :loc_postalcodes )

def read_locs
  hash = {}
  CSV.foreach( 'dl/orte.csv', CSV_OPTS ) do |row|
    l = Loc.new( row[0], row[1], row[2], row[3], row[4] )
    hash[ l.loc_num ] = l
  end
  hash
end

