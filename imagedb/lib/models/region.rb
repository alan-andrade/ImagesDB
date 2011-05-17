class Region < ActiveRecord::Base

  belongs_to :image

  # Each color has 21845 instead of 255.
  NORMAL      = 15_000
  HOMOGENEITY = lambda do |p1,p2|
    if (p1.red - p2.red)     .abs  <= NORMAL &&
       (p1.green - p2.green) .abs  <= NORMAL &&
       (p1.blue  - p2.blue)  .abs  <= NORMAL
      return true
    else
      return false
    end
  end

  def homogeneous?
    image.each_pair_pixels(self) do |p1,p2|
      @homogeneus = HOMOGENEITY.call(p1,p2)
      break unless @homogeneus
    end
    @homogeneus
  end

  def split
    raise "Bad measures" if xub > xlb or yub > ylb
    if xub != xlb
      returnable = vertical_split
    else
      returnable = horizontal_split
    end

    return returnable
  end

  def adjacent(candidate)
    # Check X axis.
    x_range = (xub-1)..(xlb+1)
    y_range = (yub-1)..(ylb+1)
    if x_range.include?(candidate.xub) or x_range.include?(candidate.xlb)
      if y_range.include?(candidate.yub) or y_range.include?(candidate.ylb)
        return true
      end
    end
    return false
  end

  def union(region)
    xub  = min_xub = [self.xub,region.xub].min
    yub  = min_yub = [self.yub,region.yub].min
    xlb  = max_xlb = [self.xlb,region.xlb].max
    ylb  = max_ylb = [self.ylb,region.ylb].max
  end

  def to_s
    "REGION: x1: #{xub} , y1: #{yub} , x2: #{xlb}, y2: #{ylb}"
  end

  private

  def vertical_split
    # Corresponde al eje X.
    cutted_x = if xub == 0
                  xlb/2
                else
                  (xlb+xub)/2
                end

    [ image.regions.build(:xub=>xub,:yub=>yub, :xlb=>cutted_x, :ylb=>ylb)  ,
      image.regions.build(:xub=>cutted_x+1, :yub=>yub, :xlb=>xlb, :ylb=>ylb) ]

  end

  def horizontal_split
    cutted_y = if yub == 0
                  ylb/2
                else
                  (ylb+yub)/2
                end

    [ image.regions.build(:xub=>xub,:yub=>yub, :xlb=>xlb, :ylb=>cutted_y) ,
      image.regions.build(:xub=>xub,:yub=>cutted_y+1, :xlb=>xlb, :ylb=>ylb) ]
  end


end

