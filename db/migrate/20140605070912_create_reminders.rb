class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.float :value
      t.integer :priority_id
      t.integer :value
      t.integer :company_id
      t.integer :time_line
      t.datetime :last_sent
      t.integer :to
      t.integer :cc
      t.integer :mail_count

      t.timestamps
    end

    add_index :reminders, :priority_id
    add_index :reminders, :company_id
  end
end
