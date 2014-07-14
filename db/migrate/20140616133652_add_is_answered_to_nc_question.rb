class AddIsAnsweredToNcQuestion < ActiveRecord::Migration
  def change
    add_column :nc_questions, :is_answered, :boolean, :default => false
  end
end
