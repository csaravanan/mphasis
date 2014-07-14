class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.integer :location_id

      t.timestamps
    end

    add_index :departments, :location_id
  end
end
