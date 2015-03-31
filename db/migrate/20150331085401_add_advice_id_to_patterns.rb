class AddAdviceIdToPatterns < ActiveRecord::Migration
  def change
    add_column :patterns, :advice_id, :integer
  end
end
