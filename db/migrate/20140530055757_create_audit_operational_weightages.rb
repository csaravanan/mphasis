class CreateAuditOperationalWeightages < ActiveRecord::Migration
  def change
    create_table :audit_operational_weightages do |t|
      t.integer :operational_area_id
      t.integer :audit_id
      t.integer :weightage
      t.integer :total_score
      t.integer :percentage

      t.timestamps
    end

    add_index :audit_operational_weightages, :operational_area_id
    add_index :audit_operational_weightages, :audit_id
  end
end
