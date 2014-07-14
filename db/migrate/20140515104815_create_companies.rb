class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :primary_email
      t.string :secondary_email
      t.string :domain
      t.string :address1
      t.string :address2
      t.string :timezone
      t.integer :country_id
      t.string :contact_no
      t.boolean :is_disabled, :default => false

      t.timestamps
    end

    add_index :companies, :country_id
  end
end
