require "entry"

class EntryQuicktime < Entry
  SOURCE_NAME = "quicktime"

  def thumb_url
    "https://video.steinkamp.us/#{uid}.jpg"
  end

  def self.add_new_entries(options = {})
    return
  end
end

