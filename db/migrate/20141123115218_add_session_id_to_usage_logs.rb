class AddSessionIdToUsageLogs < ActiveRecord::Migration
  def change
    add_column :usage_logs, :session_id, :integer
  end
end
