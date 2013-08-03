class AddFieldsToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :title, :string
    add_column :articles, :preview, :text
  end
end
