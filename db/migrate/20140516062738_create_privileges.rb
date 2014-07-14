class CreatePrivileges < ActiveRecord::Migration
  def change
    create_table :privileges do |t|
      t.integer :role_id
      t.integer :modular_id
      t.timestamps
    end

    add_index :privileges, :role_id
    add_index :privileges, :modular_id
  end
end
