class ChangeUsersHistoryType < ActiveRecord::Migration
   def up
    change_column :users, :history, :text 
  end

  def down
    change_column :users, :history, :string
  end
end
