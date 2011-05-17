class CreateRegionTable < ActiveRecord::Migration
  def self.up
    create_table :regions, :force=>true do |t|
      t.references :image
      t.integer :xub
      t.integer :xlb
      t.integer :yub
      t.integer :ylb
      t.string  :object
    end 
  end
  
  def self.down
    drop_table  :regions
  end
end
