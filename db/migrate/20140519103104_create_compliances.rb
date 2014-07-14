class CreateCompliances < ActiveRecord::Migration
  def change
    create_table :compliances do |t|
      t.string :name

      t.timestamps
    end
  end
end