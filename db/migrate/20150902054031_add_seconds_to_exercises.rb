class AddSecondsToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :seconds, :float
  end
end
