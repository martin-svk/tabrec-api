class ChangeUserIdToString < ActiveRecord::Migration
  def change
    change_column :users, :id, :string
  end
end
