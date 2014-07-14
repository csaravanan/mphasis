class CreatePlanningStrategies < ActiveRecord::Migration
  def change
    create_table :planning_strategies do |t|
      t.string :name

      t.timestamps
    end
  end
end
