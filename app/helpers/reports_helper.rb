module ReportsHelper
  def get_weeks(n)
    (0..n).map { |i| (Date.today - i.weeks).at_beginning_of_week }
  end

  def report_color(report_item)
    return report_item.color if report_item.respond_to?(:color) && report_item.color.present?
    "#6c757d" # Default grey
  end

  def build_history_table(history_data)
    # Modernizing build_table
    content_tag(:div, class: "table-responsive mb-3") do
      content_tag(:table, class: "table table-sm table-bordered table-striped text-center") do
        header = content_tag(:thead, class: "table-light") do
          content_tag(:tr) do
            get_weeks(history_data.size - 1).reverse.map do |w|
              content_tag(:th, w.strftime("%m/%d"))
            end.join.html_safe
          end
        end

        body = content_tag(:tbody) do
          content_tag(:tr) do
            history_data.map do |value|
              content_tag(:td, value)
            end.join.html_safe
          end
        end

        header + body
      end
    end + content_tag(:div, "(number of times per week)", class: "small text-muted mb-4")
  end

  def build_summary_table(hash)
    # Modernizing build_table_from_hash
    content_tag(:div, class: "table-responsive mb-4 shadow-sm border overflow-hidden") do
      content_tag(:table, class: "table table-hover mb-0") do
        header = content_tag(:thead, class: "table-dark") do
          content_tag(:tr) do
            hash.keys.map { |k| content_tag(:th, k.to_s.humanize) }.join.html_safe
          end
        end

        body = content_tag(:tbody) do
          content_tag(:tr) do
            hash.values.map { |v| content_tag(:td, v) }.join.html_safe
          end
        end

        header + body
      end
    end
  end
end
