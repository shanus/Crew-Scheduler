class Color
  attr_reader :color_array
  attr_reader :grey_array
 
  def self.color_array
   ["#B02B2C","#D15600","#C79810","#73880A","#6BBA70",
    "#3F4C6B","#356AA0","#D01F3C","#326896","#73a395"]
  end
  
  def self.grey_array
    ["#EDECE8","#83838D","#75747A","#4D4E52","#C8D0CB"]
  end
  
  def self.random
    return color_array[rand(10)]
  end
  
  def self.random_grey
    return grey_array[rand(5)]
  end
end

