class CreateNextSteps < ActiveRecord::Migration
  def change
    create_table :next_steps do |t|
      t.string :name

      t.timestamps
    end
  end
end
