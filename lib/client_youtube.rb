require "rexml/document"
require "open-uri"
require "publish_fb"

class ClientYoutube
  def initialize(options = {})
    @username = options[:username] || "thenobot"
  end

  def get_videos
    endpoint = "https://www.youtube.com/feeds/videos.xml?user=#{@username}"
    response = REXML::Document.new(open(endpoint).read)

    response.elements.collect("feed/entry") do |item|
      {
        :pub_date => item.elements["published"].text,
        :title => item.elements["title"].text,
        :link => "https://www.youtube.com/watch?v=#{item.elements["yt:videoId"].text}&hd=1",
        :description => item.elements["media:group"].elements["media:description"].text,
        :id => item.elements["yt:videoId"].text
      }
    end
  end
end
