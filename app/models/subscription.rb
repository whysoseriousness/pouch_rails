class Subscription < ActiveRecord::Base
  attr_accessible :source_id, :user_id
  belongs_to :user
  belongs_to :source
end
