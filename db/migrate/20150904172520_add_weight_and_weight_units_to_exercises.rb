class AddWeightAndWeightUnitsToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :weight, :float
    add_column :exercises, :weight_units, :string
  end
end
