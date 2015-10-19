class RenameExerciseSetsToESets < ActiveRecord::Migration
  def change
   rename_table :exercise_sets, :e_sets
  end
end
