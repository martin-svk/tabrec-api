class AddNameIndexToResolutions < ActiveRecord::Migration
  def change
    add_index :resolutions, :name
  end
end
