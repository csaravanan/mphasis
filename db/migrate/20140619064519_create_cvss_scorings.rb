class CreateCvssScorings < ActiveRecord::Migration
  def change
    create_table :cvss_scorings do |t|
      t.integer :cvss_access_vector
      t.integer :cvss_access_complexity
      t.integer :cvss_authentication
      t.integer :cvss_conf_impact
      t.integer :cvss_integ_impact
      t.integer :cvss_avail_impact
      t.integer :cvss_exploitability
      t.integer :cvss_remediation_level
      t.integer :cvss_report_confidence
      t.integer :cvss_collateral_damage_potential
      t.integer :cvss_target_distribution
      t.integer :cvss_confidentiality_requirement
      t.integer :cvss_integrity_requirement
      t.integer :cvss_availability_requirement
      t.timestamps
    end
    
    add_index :cvss_scorings, :cvss_access_vector
    add_index :cvss_scorings, :cvss_access_complexity
    add_index :cvss_scorings, :cvss_authentication
    add_index :cvss_scorings, :cvss_conf_impact
    add_index :cvss_scorings, :cvss_integ_impact
    add_index :cvss_scorings, :cvss_avail_impact
    add_index :cvss_scorings, :cvss_exploitability
    add_index :cvss_scorings, :cvss_remediation_level
    add_index :cvss_scorings, :cvss_report_confidence
    add_index :cvss_scorings, :cvss_collateral_damage_potential
    add_index :cvss_scorings, :cvss_target_distribution
    add_index :cvss_scorings, :cvss_confidentiality_requirement
    add_index :cvss_scorings, :cvss_integrity_requirement
    add_index :cvss_scorings, :cvss_availability_requirement
    
  end
end
