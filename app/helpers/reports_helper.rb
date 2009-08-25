module ReportsHelper
  def report_color(report_item)
    return report_item.color unless report_item.color.blank?
    Color.random_grey
  end
  
  def pie_colors(hash, type)
    colors = []
    output = "<colors>"
    case type
    when "boat"
      hash.each do |index,value|
        c = Boat.find_by_name(index).color || Color.random_grey
        colors << c
      end
    when "crew"
      hash.each do |index,value|
        c = Team.find_by_name(index).color || Color.random_grey
        colors << c
      end
    end
    colors.compact
    output << colors.join(",")
    # do I need to strip trailing comma?  -slm 05/31/08
    output << "</colors>"
    return output
  end
  
  def build_table(history)
    html = "<table class='report'><tr>"
    get_weeks(history.size - 1).each do |w|
      html << "<th>#{w.strftime('%m/%d')}</th>"
    end
    html << "</tr><tr>"
    history.each do |value|
      html << "<td>#{value}</td>"
    end
    html << "</tr></table>"
    html << "(number of times per week)<br /><br />"
    return html
  end
  
  def flash_warning
    html = "<p>To see this page properly, you need to upgrade your Flash Player, please "
    html << (link_to "visit the Adobe web site", "http://www.adobe.com/go/getflashplayer", :target => "_blank")
    html << "</p>"
    return html
  end
  
  def build_table_from_hash(hash)
    html = "<table class='report'><tr>"
    hash.each do |index,value|
      html << "<th>#{index}</th>"
    end
    html << "</tr><tr>"
    hash.each do |value|
      html << "<td>#{value}</td>"
    end
    html << "</tr></table>"
    html << "<br /><br />"
    return html
  end
end
