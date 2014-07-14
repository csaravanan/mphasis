class AddRatingToAuditOperationalWeightage < ActiveRecord::Migration
  def change
    add_column :audit_operational_weightages, :rating, :integer
  end
end
