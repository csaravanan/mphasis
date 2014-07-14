class CreateRiskStatuses < ActiveRecord::Migration
  def change
    create_table :risk_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
