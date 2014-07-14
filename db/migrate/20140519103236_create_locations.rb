class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.integer :company_id

      t.timestamps
    end

    add_index :locations, :company_id
  end
end
