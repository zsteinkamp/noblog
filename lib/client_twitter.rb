require "rexml/document"
require "open-uri"
require "publish_fb"

class ClientTwitter
  def initialize(options = {})
    @user_id = options[:user_id] || "6142272"
  end

  def get_tweets
    endpoint = "http://twitter.com/statuses/user_timeline/#{@user_id}.rss"
    response = REXML::Document.new(open(endpoint).read)

    response.elements.collect("rss/channel/item") do |item|
      next if item.elements["title"].text.match(/^[^:]+: \@/) # exclude replies
      {
        :pub_date => item.elements["pubDate"].text,
        :title => item.elements["title"].text,
        :link => item.elements["link"].text,
        :id => item.elements["link"].text.match(/statuses\/([\d]+)/)[1],
      }
    end.compact
  end
end
