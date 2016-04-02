require "entry"
require "client_twitter"

class EntryTwitter < Entry
  SOURCE_NAME = "twitter"

  def disp_title
    # remove leading username
    super.gsub(/^[^:]+: /,"")
  end

  def thumb_url
    if (matches = data[:title].match(/(http:\/\/yfrog.com\/[a-z0-9]+)/))
      return "#{matches[1]}.th.jpg"
    elsif (matches = data[:title].match(/(http:\/\/tweetphoto.com\/\d+)/))
      return "http://tweetphotoapi.com/api/TPAPI.svc/imagefromurl?size=small&url=#{matches[1]}"
    end
    data[:thumb_url] || super
  end
  
  def fb_link
    nil
  end

  def self.add_new_entries(options = {})
    client = ClientTwitter.new(options)
    result = []
    client.get_tweets.each do |tweet|
      unless Entry.find_by_source_and_uid(SOURCE_NAME, tweet[:id])
        entry = self.create(
          :source => SOURCE_NAME, 
          :uid => tweet[:id], 
          :pub_date => Time.parse(tweet[:pub_date]), 
          :data => tweet
        )
        entry.publish_to_fb
        result << "Added Tweet [#{tweet[:title]}]"
      end
    end
    result
  end
end
