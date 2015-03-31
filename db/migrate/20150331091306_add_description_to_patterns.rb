class AddDescriptionToPatterns < ActiveRecord::Migration
  def change
    add_column :patterns, :desc, :string
  end
end
