require "entry"
require "client_strava"

class EntryStrava < Entry
  SOURCE_NAME = "strava"

  def thumb_url
    # choose run or bike
    "strava_#{data[:activity_type].downcase}_150.png"
  end

  def self.add_new_entries(options = {})
    client = ClientStrava.new(options)
    result = []
    client.get_activities.each do |activity|
      unless Entry.find_by_source_and_uid(SOURCE_NAME, activity[:id])
        entry = self.create(
          :source => SOURCE_NAME,
          :uid => activity[:id],
          :pub_date => Time.parse(activity[:pub_date]),
          :data => activity
        )
        entry.publish_to_fb
        result << "Added Strava activity [#{activity[:title]}]"
      end
    end
    result
  end
end
