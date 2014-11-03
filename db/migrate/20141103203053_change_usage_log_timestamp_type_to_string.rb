class ChangeUsageLogTimestampTypeToString < ActiveRecord::Migration
  def change
    change_column :usage_logs, :timestamp, :string
  end
end
