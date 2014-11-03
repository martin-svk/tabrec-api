class AddTabIdAndTimestampToUsageLogs < ActiveRecord::Migration
  def change
    add_column :usage_logs, :tab_id, :integer
    add_column :usage_logs, :timestamp, :datetime
  end
end
