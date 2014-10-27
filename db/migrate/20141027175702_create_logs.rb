class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.references :user
      t.references :event
      t.references :advice
      t.references :resolution
      t.timestamps
    end
  end
end
