class AddIsNcqAnsweredToAudit < ActiveRecord::Migration
  def change
    add_column :audits, :is_ncq_answered, :boolean, :default => false
  end
end
