class Article < ActiveRecord::Base
  attr_accessible :file_path, :url, :title, :preview, :updated, :author, :published, :source_id, :page_content
  belongs_to :source
end
