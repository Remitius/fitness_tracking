class RemoveSecondsPoundsAndRepsFromExercises < ActiveRecord::Migration
  def change
    remove_column :exercises, :seconds
    remove_column :exercises, :reps
    remove_column :exercises, :pounds
  end
end
