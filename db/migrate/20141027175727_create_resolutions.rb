class CreateResolutions < ActiveRecord::Migration
  def change
    create_table :resolutions do |t|
      t.string :name
      t.text :desc
      t.timestamps
    end
  end
end
