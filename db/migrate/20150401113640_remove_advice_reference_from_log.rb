class RemoveAdviceReferenceFromLog < ActiveRecord::Migration
  def change
    remove_column :logs, :advice_id, :integer
  end
end
