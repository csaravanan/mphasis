class RemoveIsAnsweredFromAudit < ActiveRecord::Migration
  def change
    remove_column :audits, :is_ncq_answered, :boolean
  end
end
