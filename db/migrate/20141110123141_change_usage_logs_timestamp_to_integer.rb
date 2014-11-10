class ChangeUsageLogsTimestampToInteger < ActiveRecord::Migration
  def change
    UsageLog.destroy_all
    change_column :usage_logs, :timestamp, 'integer USING CAST(timestamp AS integer)'
  end
end
