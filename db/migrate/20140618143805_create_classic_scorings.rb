class CreateClassicScorings < ActiveRecord::Migration
  def change
    create_table :classic_scorings do |t|
      t.integer :likelihood
      t.integer :impact
      t.integer :velocity
      t.integer :vulnerability
      t.timestamps
    end
    
  add_index :classic_scorings, :likelihood
  add_index :classic_scorings, :impact
  add_index :classic_scorings, :velocity
  add_index :classic_scorings, :vulnerability
  end
end
