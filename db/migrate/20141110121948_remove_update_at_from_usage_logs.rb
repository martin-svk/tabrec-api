class RemoveUpdateAtFromUsageLogs < ActiveRecord::Migration
  def change
    remove_column :usage_logs, :updated_at
  end
end
