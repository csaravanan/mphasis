class CreateAuditCompliances < ActiveRecord::Migration
  def change
    create_table :audit_compliances do |t|
      t.integer :compliance_library_id
      t.integer :audit_id
      t.integer :score_id
      t.boolean :is_answered , :default => false

      t.timestamps
    end

    add_index :audit_compliances, :compliance_library_id
    add_index :audit_compliances, :audit_id
    add_index :audit_compliances, :score_id
  end
end
