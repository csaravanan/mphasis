class CreateClassicScoringMetrics < ActiveRecord::Migration
  def change
    create_table :classic_scoring_metrics do |t|
      t.string :name
      t.integer :value
      t.string :metric_type
      t.timestamps
    end
  end
end
