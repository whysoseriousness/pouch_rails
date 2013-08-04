class Article < ActiveRecord::Base
  attr_accessible :file_path, :url, :title, :preview, :updated, :author, :published, :source_id
  belongs_to :source
end
