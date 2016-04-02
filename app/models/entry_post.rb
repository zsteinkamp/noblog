require "entry"
class EntryPost < Entry
  SOURCE_NAME = "post"

  def thumb_url
    data[:thumb_url].blank? ? super : data[:thumb_url]
  end
end
