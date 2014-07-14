class CreateControlMeasures < ActiveRecord::Migration
  def change
    create_table :control_measures do |t|
      t.integer :risk_id
      t.string :control_ids, array: true, default: []
      t.text :threat
      t.text :consequence
      t.string :effectiveness
      t.integer :risk_scoring_id
      t.string :process_ids, array: true, default: []
      t.string :procedure_ids, array: true, default: []

      t.timestamps
    end

    add_index :control_measures, :risk_id
    add_index :control_measures, :risk_scoring_id
  end
end
