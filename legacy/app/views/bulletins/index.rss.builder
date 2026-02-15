xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title(BULLETINRSSTITLE)
    xml.link("http://#{YOURSITE}/bulletins.rss")
    xml.description(BULLETINRSSDESC)
    xml.language('en-us')

    for bulletin in @bulletins
      xml.item do
        xml.title(h(bulletin.title))
        xml.category 
        xml.description(h(bulletin.body))
        xml.pubDate(bulletin.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.link("http://#{YOURSITE}/bulletins/" + bulletin.id.to_s)
        xml.guid("http://#{YOURSITE}/bulletins/" + bulletin.id.to_s)
        xml.author(h(bulletin.user.name.capitalize))
      end
    end
  }
}