class AddFieldsToSubscription < ActiveRecord::Migration
  def change
  	change_column :subscriptions,:valid_period,:string
  	add_column :subscriptions,:user_count,:integer
  	add_column :subscriptions,:file_size,:integer
  end
end
