class ChangeFieldNameInTransaction < ActiveRecord::Migration
  def change
  	rename_column :transactions,:token, :transaction_id
  	rename_column :transactions,:payer_id, :profile_id
  	remove_column :transactions,:identifier
  	change_column :transactions,:card_number,:string
  	remove_column :transactions,:pay_cancel
  	remove_column :transactions,:first_name
  	remove_column :transactions,:last_name
  	remove_column :transactions,:card_type
  	remove_column :transactions,:card_expires_on
  	remove_column :transactions,:card_verification
  end
end
