class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|

      t.integer	:user_id
      t.string  :personal_email
      t.string  :phone_no
      t.string  :address1
      t.string  :address2
      t.string  :city
      t.string  :state
      t.integer  :country_id

      t.timestamps
    end

    add_index :profiles, :user_id
    add_index :profiles, :country_id
  end
end
