require "entry"
require "client_instagram"

class EntryInstagram < Entry
  SOURCE_NAME = "instagram"

  def thumb_url
    data[:thumb_url].blank? ? super : data[:thumb_url]
  end

  def self.add_new_entries(options = {})
    result = []
    client = ClientInstagram.new(options)
    client.get_photos.each do |img|
      unless Entry.find_by_source_and_uid(SOURCE_NAME, img[:id])
        entry = self.create(
          :source => SOURCE_NAME,
          :uid => img[:id],
          :pub_date => img[:pub_date],
          :data => img
        )
        result << "Added img [#{img[:title]}]"
      end
    end
    result
  end
end

