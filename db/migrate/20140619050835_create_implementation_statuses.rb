class CreateImplementationStatuses < ActiveRecord::Migration
  def change
    create_table :implementation_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
