xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "OpenStreetMap Activities"

    for activity in @activities
      xml.item do
        xml.title activity.title
        xml.description activity.content
        xml.pubDate activity.published_at.to_s(:rfc822)
      end
    end
  end
end
