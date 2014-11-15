class ChangeUserIdOnLogsToString < ActiveRecord::Migration
  def change
    change_column :logs, :user_id, :string
    change_column :usage_logs, :user_id, :string
  end
end
