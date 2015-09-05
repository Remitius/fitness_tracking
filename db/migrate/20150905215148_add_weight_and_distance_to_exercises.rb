class AddWeightAndDistanceToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :weight_in_pounds, :float
    add_column :exercises, :distance_in_meters, :float
  end
end
