xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
history =  @boat.rowing_history(16)

unless history == Array.new(history.size, 0)
  xml.chart do
    xml.series do    
      get_weeks(history.size).each_with_index do |w, index|
        xml.value w.strftime("%m/%d"), :xid => index
      end
    end

color = report_color(@boat)

    xml.graphs do
      xml.graph :gid => 'boats' do
       history.each_with_index do |count, index|
          case count.to_i
            when 0..4
              xml.value count, :xid => index, :color => color
            else
              xml.value count, :xid => index, :color => color, :gradient_fill_colors => "#FFFFFF,#{color}"
          end
        end
      end
    end
  end
end