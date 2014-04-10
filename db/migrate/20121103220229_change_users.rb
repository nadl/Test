class ChangeUsers < ActiveRecord::Migration
  def up
    change_column :users, :since_id, :string
  end

  def down
    change_column :users, :since_id, :integer
  end
end
