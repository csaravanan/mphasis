class CreateClosures < ActiveRecord::Migration
  def change
    create_table :closures do |t|
      t.integer :risk_id
      t.integer :user_id
      t.date :closure_date
      t.integer :close_reason_id
      t.text :note

      t.timestamps
    end

    add_index :closures, :risk_id
    add_index :closures, :user_id
    add_index :closures, :close_reason_id
  end
end
