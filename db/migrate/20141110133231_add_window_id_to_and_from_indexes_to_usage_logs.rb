class AddWindowIdToAndFromIndexesToUsageLogs < ActiveRecord::Migration
  def change
    add_column :usage_logs, :window_id, :integer
    add_column :usage_logs, :index_from, :integer
    add_column :usage_logs, :index_to, :integer
  end
end
