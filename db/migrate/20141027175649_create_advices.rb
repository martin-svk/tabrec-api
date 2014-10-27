class CreateAdvices < ActiveRecord::Migration
  def change
    create_table :advices do |t|
      t.string :name
      t.text :desc
      t.timestamps
    end
  end
end
