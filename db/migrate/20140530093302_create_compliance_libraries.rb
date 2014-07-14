class CreateComplianceLibraries < ActiveRecord::Migration
  def change
    create_table :compliance_libraries do |t|
      t.string  :name
      t.integer :compliance_id
      t.boolean :is_leaf
      t.integer :parent_id

      t.timestamps
    end

    add_index :compliance_libraries, :compliance_id
    add_index :compliance_libraries, :parent_id
  end
end