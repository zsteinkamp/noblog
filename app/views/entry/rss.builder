xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do

    xml.title       "steinkamp.us"
    xml.link        url_for :only_path => false, :controller => 'entry'
    xml.description "Steinkamp web life, collected."

    @entries.each do |entry|
      xml.item do
        xml.title       entry.disp_title
        xml.description entry.data[:desc] || entry.data[:description] || entry.data[:excerpt] || " "
        xml.link        "#{entry.permalink(true)}"
        xml.guid        "#{entry.permalink(true)}"
      end
    end
  end
end
