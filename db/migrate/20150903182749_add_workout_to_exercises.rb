class AddWorkoutToExercises < ActiveRecord::Migration
  def change
    add_reference :exercises, :workout, index: true, foreign_key: true
  end
end
