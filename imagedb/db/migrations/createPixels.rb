class CreatePixelTable < ActiveRecord::Migration
  def self.up
    create_table :pixels, :force=>true do |t|
      t.references :image
      t.integer :x
      t.integer :y
      t.integer :red
      t.integer :green
      t.integer :blue
    end 
  end
  
  def self.down
    drop_table  :pixels
  end
end
