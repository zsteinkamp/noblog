require "entry"
require "client_youtube"

class EntryYoutube < Entry
  SOURCE_NAME = "youtube"

  def thumb_url
    "http://i.ytimg.com/vi/#{data[:id]}/default.jpg" || super
  end

  def self.add_new_entries(options = {})
    client = ClientYoutube.new(options)
    result = []
    client.get_videos.each do |video|
      unless Entry.find_by_source_and_uid(SOURCE_NAME, video[:id])
        entry = self.create(
          :source => SOURCE_NAME, 
          :uid => video[:id], 
          :pub_date => Time.parse(video[:pub_date]), 
          :data => video 
        )
        entry.publish_to_fb
        result << "Added YouTube video [#{video[:title]}]"
      end
    end
    result
  end
end
