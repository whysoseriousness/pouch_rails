class Source < ActiveRecord::Base
  attr_accessible :name, :url
  has_many :articles
end
