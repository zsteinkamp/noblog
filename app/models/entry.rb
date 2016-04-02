require 'publish_fb'

class Entry < ActiveRecord::Base
  has_many :comments
  after_save :clear_timeline_cache
  serialize :data, Hash

  attr_accessible :data, :pub_date, :source, :uid

  def clear_timeline_cache
    TimelineCache.delete_all
  end

  def disp_title
    return "" unless data && data[:title]
    ret = data[:title]
    ret.gsub(/^\d{8} /,"")
  end

  def permalink(absolute = false)
    "#{absolute ? "http://steinkamp.us" : ""}/#{self.id}/#{self.data[:title].downcase.gsub(/[^a-z0-9]/,"-").gsub(/-+/,"-").gsub(/^-/,"").gsub(/-$/,"")}"
  end

  def fb_link
    permalink(true)
  end

  def thumb_url
    "/1px.gif"
  end

  def publish_to_fb
    return true # temp disable
    unless ENV['NO_FB']
      result = PublishFB.new.publish(self)
      unless result.class == Net::HTTPOK
        # retry once
        result = PublishFB.new.publish(self)
      end
      result
    end
  end

  def self.instantiate(record)
    super(record).source_class
  end

  def source_class
    self.becomes("entry_#{self.source}".camelize.constantize)
  end
end
