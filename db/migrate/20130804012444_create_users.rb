class CreateUsers < ActiveRecord::Migration
  def change
    drop_table :users
    create_table :users do |t|

      t.timestamps
    end
  end
end
