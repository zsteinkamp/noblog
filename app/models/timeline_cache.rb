class TimelineCache < ActiveRecord::Base
  attr_accessible :data, :tl_hash

  self.table_name = "timeline_cache"

  serialize :data, Hash
end

