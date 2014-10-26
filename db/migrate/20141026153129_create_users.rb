class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :experience_level
      t.timestamps
    end
  end
end
