class CreateExerciseSets < ActiveRecord::Migration
  def change
    create_table :exercise_sets do |t|
      t.float :pounds
      t.integer :reps
      t.references :exercise, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
