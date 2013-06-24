require "rexml/document"
require "open-uri"
require "publish_fb"

class ClientYoutube
  def initialize(options = {})
    @username = options[:username] || "thenobot"
  end

  def get_videos
    endpoint = "http://gdata.youtube.com/feeds/base/users/#{@username}/uploads?alt=rss&v=2"
    response = REXML::Document.new(open(endpoint).read)

    response.elements.collect("rss/channel/item") do |item|
      desc_doc = REXML::Document.new(item.elements["description"].text.gsub(/(<(img|br)[^>]*)>/, "$1/>"))
      bare_desc = item.elements["description"].text.match(/<span>([^<]*)<\/span>/)[1]
      {
        :pub_date => item.elements["pubDate"].text,
        :title => item.elements["title"].text,
        :link => "#{item.elements["link"].text}&hd=1",
        :description => bare_desc,
        :id => item.elements["link"].text.match(/v=([^&]+)/)[1],
      }
    end
  end
end
