class AddNameToPatterns < ActiveRecord::Migration
  def change
    add_column :patterns, :name, :string
    add_index :patterns, :name
  end
end
