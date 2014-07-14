class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.integer :company_id
      t.string :address1
      t.string :address2
      t.string :contact_no
      t.string :email


      t.timestamps
    end

    add_index :clients, :company_id
  end
end
