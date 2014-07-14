class CreateCppMeasures < ActiveRecord::Migration
  def change
    create_table :cpp_measures do |t|
      t.string :name
      t.string :description
      t.string :measure_type
      t.integer :implementation_status_id
      t.integer :compliance_id
      t.string :duration
      t.integer :company_id

      t.timestamps
    end

    add_index :cpp_measures, :implementation_status_id
    add_index :cpp_measures, :compliance_id
    add_index :cpp_measures, :company_id
  end
end
