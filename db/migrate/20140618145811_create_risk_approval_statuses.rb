class CreateRiskApprovalStatuses < ActiveRecord::Migration
  def change
    create_table :risk_approval_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
