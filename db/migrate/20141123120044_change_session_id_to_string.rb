class ChangeSessionIdToString < ActiveRecord::Migration
  def change
    change_column :usage_logs, :session_id, :string
  end
end
