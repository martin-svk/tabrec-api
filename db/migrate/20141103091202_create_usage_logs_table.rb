class CreateUsageLogsTable < ActiveRecord::Migration
  def change
    create_table :usage_logs do |t|
      t.references :user
      t.references :event
      t.timestamps
    end
  end
end
