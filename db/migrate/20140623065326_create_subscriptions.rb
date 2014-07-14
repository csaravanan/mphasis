class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.string :description
      t.string :section_ids,array: true,default: []
      t.float :amount
      t.integer :valid_log
      t.integer :valid_period
      t.timestamps
    end
  end
end
