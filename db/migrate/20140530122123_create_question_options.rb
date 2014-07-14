class CreateQuestionOptions < ActiveRecord::Migration
  def change
    create_table :question_options do |t|
      t.integer :nc_question_id
      t.string :value

      t.timestamps
    end

    add_index :question_options, :nc_question_id
  end
end
