class CreateImagesTable < ActiveRecord::Migration
  def self.up
    create_table :images, :force  =>  true do |t|
      t.string :name
    end
  end
  
  def self.down
    drop_table  :images
  end
end
