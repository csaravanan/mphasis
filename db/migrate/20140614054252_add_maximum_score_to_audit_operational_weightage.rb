class AddMaximumScoreToAuditOperationalWeightage < ActiveRecord::Migration
  def change
    add_column :audit_operational_weightages, :maximum_score, :integer
  end
end
