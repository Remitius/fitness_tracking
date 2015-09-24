class RenameRepetitions < ActiveRecord::Migration
  def change
    rename_column :exercises, :repetitions, :reps
  end
end
