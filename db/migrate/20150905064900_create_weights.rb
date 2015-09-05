class CreateWeights < ActiveRecord::Migration
  def change
    create_table :weights do |t|
      t.float :measurement
      t.string :unit

      t.timestamps null: false
    end
  end
end
