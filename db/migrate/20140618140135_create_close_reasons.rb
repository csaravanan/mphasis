class CreateCloseReasons < ActiveRecord::Migration
  def change
    create_table :close_reasons do |t|
      t.string :name

      t.timestamps
    end
  end
end
