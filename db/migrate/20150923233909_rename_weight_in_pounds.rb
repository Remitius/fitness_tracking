class RenameWeightInPounds < ActiveRecord::Migration
  def change
    rename_column :exercises, :weight_in_pounds, :pounds
  end
end
