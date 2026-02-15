data = @crew_breakdown["#{@boat.name}"]

xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"

xml.pie do
  data.each do |index, value|
    xml.slice value, :title => index
  end
end