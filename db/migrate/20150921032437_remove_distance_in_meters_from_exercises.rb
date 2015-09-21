class RemoveDistanceInMetersFromExercises < ActiveRecord::Migration
  def change
    remove_column :exercises, :distance_in_meters
  end
end
