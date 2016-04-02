require "entry"
require "client_vimeo"

class EntryVimeo < Entry
  SOURCE_NAME = "vimeo"

  def thumb_url
    data[:thumbnail_url] || super
  end

  def self.add_new_entries(options = {})
    client = ClientVimeo.new(options)
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
        result << "Added Vimeo video [#{video[:title]}]"
      end
    end
    result
  end
end
