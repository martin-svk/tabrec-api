class AddNameIndexToAdvices < ActiveRecord::Migration
  def change
    add_index :advices, :name
  end
end
