class HullType
  attr_reader :name, :options

  HullOption = Struct.new(:value, :name)

  def initialize(name)
    @name = name
    @options = []
  end

  def <<(option)
    @options << option
  end

  def self.all_options
    HULL_OPTIONS.flat_map(&:options)
  end

  # Initialize constants inside the class
  SCULL = new("Sculls").tap do |s|
    s << HullOption.new("1x", "Single (1x)")
    s << HullOption.new("2x", "Double (2x)")
    s << HullOption.new("4x", "Quad (4x)")
  end

  SWEEP = new("Sweeps").tap do |s|
    s << HullOption.new("2-", "Pair (2-)")
    s << HullOption.new("2+", "Pair, coxed (2+)")
    s << HullOption.new("4-", "Four,coxless (4-)")
    s << HullOption.new("4+", "Four, coxed (4+)")
    s << HullOption.new("8+", "Eight (8+)")
  end

  HULL_OPTIONS = [SCULL, SWEEP]
end
