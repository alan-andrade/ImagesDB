PATH  = File.dirname(__FILE__) + "/"
require 'active_record'
 
task :default  =>  :migrate

task  :migrate  do
  load PATH + 'imagedb/db/connection.rb'
  Dir.foreach(PATH+'imagedb/db/migrations/') do |file|
    if file.match(/.rb/)
      klass = (load "#{PATH}/imagedb/db/migrations/" + file).first
      eval "#{klass}.up"
    end
  end
end
