class CreateMitigationEfforts < ActiveRecord::Migration
  def change
    create_table :mitigation_efforts do |t|
      t.string :name

      t.timestamps
    end
  end
end
