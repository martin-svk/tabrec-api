class RenameExpLevelAndAddRecModeToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :experience_level, :experience
    add_column :users, :rec_mode, :string
  end
end
