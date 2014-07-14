class AddFieldsToTransaction < ActiveRecord::Migration
  def change
	add_column :transactions, :first_name, :string
	add_column :transactions,:last_name,:string
	add_column :transactions,:card_type,:string
    add_column :transactions,:card_number,:bigint
    add_column :transactions,:card_verification, :integer
    add_column :transactions,:card_expires_on,:date
    add_column :transactions,:ip_address,:string
 end
end
