class CreateCvssMetricScorings < ActiveRecord::Migration
  def change
    create_table :cvss_metric_scorings do |t|
      t.string :metric_name
      t.string :abrv_metric_name
      t.string :metric_value
      t.string :abrv_metric_value
      t.float :numeric_value
      t.timestamps
    end
  end
end
