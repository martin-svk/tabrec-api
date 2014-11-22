class AddOtherPluginsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :other_plugins, :boolean, null: false, default: false
  end
end
