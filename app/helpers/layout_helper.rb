module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def auto_discovery_link(*args)
    content_for(:head) { auto_discovery_link_tag(*args) }
  end
  
  def boolean_display(value)
    value ? "Yes" : "No"
  end
  
  def blank_display(item, full_display = nil)
    full_display = item if full_display.nil?
    if item.blank?
      raw("<i>None</i>").html_safe
    else
      (full_display).html_safe
    end
  end
  
  def gravatar_url_by_email(email, size = 48)
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=mm&r=pg"
  end
  
  def telephone_link(number)
    unless number.blank?
      if mobile_platform?
        link_to number, "tel:#{number}"
      else
        link_to number, "callto:#{number}"
      end
    end
  end
  
  def delete_glyphicon
    "<i class='icon-remove'></i>".html_safe
  end
  
  def add_glyphicon
    "<i class='icon-plus'></i>".html_safe
  end
  
  def ip_link(ip_address)
    link_to ip_address, "http://whois.domaintools.com/#{ip_address}", :target => "_blank"
  end
  
  def states_array(country = "US")
    Carmen.states(country)
  end
  
  def full_address(item)
    html = ""
    html << h(item.address) + raw("<br />") unless item.address.blank?
    html << h(item.city) + ", " unless item.city.blank?
    html << h(item.state) + " " unless item.state.blank?
    html.sub!(/\,\s?$/," ")
    html << h(item.post_code) + raw("<br />") unless item.post_code.blank?
    html.sub!(/\s$/,"<br />")
    html.sub!(/\,\s?(\<br\s\/\>)?$/,raw("<br />"))
    # html << h(item.country) + raw("<br />") unless item.country.blank?
    # html << raw("<br />") unless html.match(/\<br\s\/\>?$/)
    return "" if html.strip == ","
    html.html_safe
  end
  
  def short_address(item)
    html = ""
    html << h(item.city) + ", " unless item.city.blank?
    html << h(item.state) + " " unless item.state.blank?
    html.sub!(/\,\s?$/," ")
    html.sub!(/\,\s?(\<br\s\/\>)?$/,"<br />")
    html << raw("<br />") unless html.match(/\<br\s\/\>?$/)
    return "" if html.strip == ","
    html.html_safe
  end
  
  def state_update_javascript(item)
    html = <<-eos
    <script style="text/javascript">
			jQuery(function($) {
			  // when the #country field changes
			  $("#ITEM_country").change(function() {
			    // make a GET call and replace the content
			    var country = $('select#ITEM_country :selected').val();
			    if (country == "") country="0";
			    jQuery.get('/javascript/update_state_select/' + country, function(data){
			        $("#ITEM_state").html(data);
			    });
			    return false;
			  });
			});
		</script>
		eos
		raw(html.gsub("ITEM", item))
  end
end
