class AddNoteToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :note, :string
  end
end
