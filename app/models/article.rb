class Article < ActiveRecord::Base
  attr_accessible :file_path, :url, :title, :preview, :updated, :author, :published
end
