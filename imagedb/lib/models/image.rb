class Image < ActiveRecord::Base

  has_many :pixels, :inverse_of =>  :image
  has_many :regions, :inverse_of => :image

  before_save :store_pixels

  # Image#segment se saco del libro de bases de datos multimedia.
  # Metodo de split and merge.
  def segment
    @SOL  = []
    check_split(self.to_region)
    merge
    save
  end

  def check_split(region)
    if region.homogeneous?
      addsol(region)
    else
      x = region.split
      check_split(x.first)
      check_split(x.last)
    end
  end

  def addsol(region)
    @SOL.push region
  end

  def merge
    until @SOL.empty? do
      merged = false
      candidate = @SOL.pop
      @SOL.each do |ci|
        if candidate.adjacent(ci)
          candidate.union(ci)
	        @SOL.delete ci
          merged  = true
	        regions.new(:xub=>candidate.xub,:xlb=>candidate.xlb,
		                  :ylb=>candidate.ylb,:yub=>candidate.yub)
        elsif merged
          @SOL.push(candidate)
          merged = false
        end
      end
    end
  end

  def to_region
    regions.build(:xub=>0,:yub=>0,:xlb=>columns-1,:ylb=>rows-1)
  end

  def method_missing(method, *args, &block)
      if Magick::Image.instance_methods.include?(method)
        Magick::ImageList.new(self.name).send(method, *args, &block)
      else
        super(method, *args, &block)
      end
  end

  # Auxiliar method for region homogenity recognition
  def each_pair_pixels(region)
    for y in region.yub..region.ylb
      for x in region.xub..region.xlb
        p1  = get_pixel([x,y])
        if x+1 <= region.xlb
          p2  = get_pixel([x+1,y])
        elsif y+1 <= region.ylb
          p2  = get_pixel([x,y+1])
        else
          p2  = get_pixel([x,y])
        end
        yield(p1,p2)
      end
    end
  end

  def get_pixel(coords)
    get_pixels(coords.first,coords.last,1,1)[0]
  end

  private


  def store_pixels
    each_pixel do |pixel, column, row|
      pixels << Pixel.new(:x=>column,:y=>row,:red=>pixel.red, :green=>pixel.green, :blue=>pixel.blue)
    end
  end
end

