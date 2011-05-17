class Pixel < ActiveRecord::Base
  belongs_to :image,  :inverse_of =>  :pixels
end
