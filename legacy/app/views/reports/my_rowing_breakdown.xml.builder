case params[:by]
when "crew"
  data = @crew_breakdown
when "boat"
  data = @boating_breakdown
else
  data = @seating_breakdown
end

xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"

xml.pie do
  data.each do |index, value|
    xml.slice value, :title => index
  end
end