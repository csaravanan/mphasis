class CreateAuditStatuses < ActiveRecord::Migration
  def change
    create_table :audit_statuses do |t|
      t.string :name
      t.timestamps
    end
  end
end
