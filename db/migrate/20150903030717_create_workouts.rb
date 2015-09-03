class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.string :name
      t.date :date
      t.string :note

      t.timestamps null: false
    end
  end
end
