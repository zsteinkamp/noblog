require "entry"
require "client_soundcloud"

class EntrySoundcloud < Entry
  SOURCE_NAME = "soundcloud"

  def thumb_url
    data[:artwork_url] || data[:user]["avatar_url"] || "http://a1.sndcdn.com/images/soundcloud-logo.png" || super
  end

  def self.add_new_entries(options = {})
    result = []
    client = ClientSoundcloud.new(options)
    client.get_tracks.each do |track|
      track.symbolize_keys!
      unless Entry.find_by_source_and_uid(SOURCE_NAME, track[:id])
        pub_date = track[:created_at]
        if (track[:release_day] && track[:release_month] && track[:release_year])
          pub_date = [track[:release_year], track[:release_month], track[:release_day]].join("-")
        end
        entry = self.create(
          :source => SOURCE_NAME, 
          :uid => track[:id], 
          :pub_date => pub_date,
          :data => track 
        )
        entry.publish_to_fb
        result << "Added track [#{track[:title]}]"
      end
    end
    result
  end
end

