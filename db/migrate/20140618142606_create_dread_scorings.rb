class CreateDreadScorings < ActiveRecord::Migration
  def change
    create_table :dread_scorings do |t|
      t.integer :dread_damage_potential
      t.integer :dread_reproducibility
      t.integer :dread_exploitability
      t.integer :dread_affected_users
      t.integer :dread_discoverability
      t.timestamps
    end
  end
end
