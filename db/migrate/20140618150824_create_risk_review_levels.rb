class CreateRiskReviewLevels < ActiveRecord::Migration
  def change
    create_table :risk_review_levels do |t|
      t.string :name
      t.integer :days
      t.integer :company_id
      t.integer :value

      t.timestamps
    end
    add_index :risk_review_levels, :company_id
  end
end
