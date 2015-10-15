class RemoveSetsFromExercises < ActiveRecord::Migration
  def change
    remove_column :exercises, :sets
  end
end
