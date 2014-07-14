class CreateReminderAssignments < ActiveRecord::Migration
  def change
    create_table :reminder_assignments do |t|
      t.string :name

      t.timestamps
    end
  end
end
