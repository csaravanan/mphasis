class CreateSkippedAuditReminders < ActiveRecord::Migration
  def change
    create_table :skipped_audit_reminders do |t|
      t.integer :audit_id
      t.integer :skipped_by

      t.timestamps
    end

    add_index :skipped_audit_reminders, :audit_id
  end
end
