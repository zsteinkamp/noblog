require "entry"
require "client_flickr"

class EntryFlickr < Entry
  SOURCE_NAME = "flickr"

  def thumb_url
    data[:primary_photo_url].blank? ? super : data[:primary_photo_url]
  end

  def self.add_new_entries(options = {})
    result = []
    client = ClientFlickr.new(options)
    client.get_photosets.each do |set|
      unless Entry.find_by_source_and_uid(SOURCE_NAME, set[:id])
        set = client.get_set_extras(set)
        entry = self.create(
          :source => SOURCE_NAME, 
          :uid => set[:id], 
          :pub_date => set[:pub_date], 
          :data => set 
        )
        entry.publish_to_fb
        result << "Added set [#{set[:title]}]"
      end
    end
    result
  end
end
