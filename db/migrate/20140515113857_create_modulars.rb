class CreateModulars < ActiveRecord::Migration
  def change
    create_table :modulars do |t|
      t.string :model_name
      t.string :action_name
      t.integer :section_id

      t.timestamps
    end

    add_index :modulars, :section_id
  end
end
