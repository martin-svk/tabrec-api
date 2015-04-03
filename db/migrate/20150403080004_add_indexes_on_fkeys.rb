class AddIndexesOnFkeys < ActiveRecord::Migration
  def change
    add_index :logs, :user_id
    add_index :logs, :pattern_id
    add_index :logs, :resolution_id

    add_index :usage_logs, :user_id
    add_index :usage_logs, :event_id

    add_index :patterns, :advice_id
  end
end
