class CreateDistances < ActiveRecord::Migration
  def change
    create_table :distances do |t|
      t.float :measurement
      t.string :unit

      t.timestamps null: false
    end
  end
end
