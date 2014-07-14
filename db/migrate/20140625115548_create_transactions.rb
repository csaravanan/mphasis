class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string  :token
      t.string  :identifier
      t.string  :payer_id
      t.integer :company_id
      t.integer :subscription_id
      t.boolean :pay_complete
      t.boolean :pay_cancel
      t.datetime :plan_start
      t.datetime :plan_expire
      t.timestamps
    end
  end
end
