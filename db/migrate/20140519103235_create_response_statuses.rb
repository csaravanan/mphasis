class CreateResponseStatuses < ActiveRecord::Migration
  def change
    create_table :response_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end