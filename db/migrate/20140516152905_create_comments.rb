class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps
    end

    add_index :comments, :commentable_id
    add_index :comments, :commentable_type
  end
end
