class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :subscription_id
      t.integer :company_id
      t.datetime :starts
      t.datetime :expires
      t.timestamps
    end
    add_index :plans, :subscription_id
    add_index :plans, :company_id
  end
end
