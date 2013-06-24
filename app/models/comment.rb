class Comment < ActiveRecord::Base
  belongs_to :entry

  serialize :data, Hash
end
