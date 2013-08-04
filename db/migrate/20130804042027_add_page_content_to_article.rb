class AddPageContentToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :page_content, :text
  end
end
