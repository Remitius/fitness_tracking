class AddDistanceToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :distance, :float
  end
end
