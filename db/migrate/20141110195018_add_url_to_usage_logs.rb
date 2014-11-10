class AddUrlToUsageLogs < ActiveRecord::Migration
  def change
    add_column :usage_logs, :url, :string
  end
end
