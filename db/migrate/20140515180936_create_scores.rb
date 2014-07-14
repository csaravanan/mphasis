class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :level
      t.string :description

      t.timestamps
    end
  end
end