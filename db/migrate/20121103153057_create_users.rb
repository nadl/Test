class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :twitter_handle
      t.integer :since_id
      t.string :history

      t.timestamps
    end
  end
end
