class CreateUsers < ActiveRecord::Migration
  def up
    drop_table :users
  end

  def change
    create_table :users do |t|

      t.timestamps
    end
  end
end
