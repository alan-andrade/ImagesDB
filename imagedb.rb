require 'RMagick'
require 'digest'
require 'active_record'

PATH  = File.dirname(__FILE__) + "/imagedb/"

[ 
  "db/connection.rb",   
  "lib/models/pixel.rb",  
  "lib/models/image.rb",
  "lib/models/region.rb"
].each do |file|
  require PATH + file
end
