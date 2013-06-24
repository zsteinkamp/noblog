require "rexml/document"
require "open-uri"
require "publish_fb"
require "json"

class ClientVimeo
  def initialize(options = {})
    @username = options[:username] || "thenobot"
  end

  def get_videos_rss
    endpoint = "http://vimeo.com/#{@username}/videos/rss"
    response = REXML::Document.new(open(endpoint).read)

    response.elements.collect("rss/channel/item") do |item|
      desc_doc = REXML::Document.new("<div>#{item.elements["description"].text}</div>")
      bare_desc = desc_doc.elements["div/p[2]"].text
        
      {
        :pub_date => item.elements["pubDate"].text,
        :title => item.elements["title"].text,
        :desc => bare_desc,
        :link => item.elements["link"].text,
        :id => item.elements["link"].text.match(/com\/([\d]+)/)[1],
        :thumbnail_url => item.elements["media:content/media:thumbnail"].attributes["url"],
      }
    end
  end

  def get_videos
    items = []
    3.times do |page|
      endpoint = "http://vimeo.com/api/v2/thenobot/videos.json?page=#{page + 1}"
      items += JSON.parse(open(endpoint).read).collect do |item|
        {
          :pub_date => item["upload_date"],
          :title => item["title"],
          :desc => item["description"],
          :link => item["url"],
          :id => item["id"],
          :thumbnail_url => item["thumbnail_small"]
        }
      end
    end
    items
  end
end
