class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.text :url
      t.text :file_path

      t.timestamps
    end
  end
end
