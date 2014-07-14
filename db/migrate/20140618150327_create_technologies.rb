class CreateTechnologies < ActiveRecord::Migration
  def change
    create_table :technologies do |t|
      t.string :name
      t.integer :company_id

      t.timestamps
    end

    add_index :technologies, :company_id
  end
end
