class ChangeUsageLogsTimestampToBigInt < ActiveRecord::Migration
  def change
    change_column :usage_logs, :timestamp, :integer, limit: 6
  end
end
