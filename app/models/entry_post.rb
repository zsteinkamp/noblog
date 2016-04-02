require "entry"
class EntryPost < Entry
  SOURCE_NAME = "post"

  def thumb_url
    data[:thumb_url] || super
  end
end
