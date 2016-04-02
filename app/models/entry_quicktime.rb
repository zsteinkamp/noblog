require "entry"

class EntryQuicktime < Entry
  SOURCE_NAME = "quicktime"

  def thumb_url
    "http://video.thenobot.org/#{uid}.jpg" || super
  end

  def self.add_new_entries(options = {})
    return
  end
end

