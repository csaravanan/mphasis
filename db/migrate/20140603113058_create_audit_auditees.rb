class CreateAuditAuditees < ActiveRecord::Migration
  def change
    create_table :audit_auditees do |t|
      t.integer :user_id
      t.integer :audit_id

      t.timestamps
    end

    add_index :audit_auditees, :audit_id
    add_index :audit_auditees, :user_id
  end
end
