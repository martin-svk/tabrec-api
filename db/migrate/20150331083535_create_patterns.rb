class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.string :sequence
      t.timestamps
    end
  end
end
