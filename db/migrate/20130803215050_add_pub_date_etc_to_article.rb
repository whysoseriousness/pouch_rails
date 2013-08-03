class AddPubDateEtcToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :published, :string
    add_column :articles, :updated, :string
    add_column :articles, :author, :string
  end
end
