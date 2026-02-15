class HullType
  attr_reader :type_name, :options
  def initialize(name)
    @type_name = name
    @options = []
  end
  
  def <<(option)
    @options << option
  end

  def self.all_options
    HULL_OPTIONS.flat_map(&:options)
  end
end

HullOption = Struct.new(:value, :name)

scull = HullType.new("Sculls")
scull << HullOption.new("1x", "Single (1x)")
scull << HullOption.new("2x", "Double (2x)")
scull << HullOption.new("4x", "Quad (4x)")

sweep = HullType.new("Sweeps")
sweep << HullOption.new("2-", "Pair (2-)")
sweep << HullOption.new("2+", "Pair, coxed (2+)")
sweep << HullOption.new("4-", "Four,coxless (4-)")
sweep << HullOption.new("4+", "Four, coxed (4+)")
sweep << HullOption.new("8+", "Eight (8+)")

HULL_OPTIONS = [ scull, sweep ]
