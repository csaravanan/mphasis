class CreateAuditTypes < ActiveRecord::Migration
  def change
    create_table :audit_types do |t|
      t.string :name
      t.timestamps
    end

  end
end
