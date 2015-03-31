class AddPatternReferenceToLogsRemoveOldEventReference < ActiveRecord::Migration
  def change
    remove_column :logs, :event_id, :integer
    add_column :logs, :pattern_id, :integer
  end
end
