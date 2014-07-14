class CreateOwaspScorings < ActiveRecord::Migration
  def change
    create_table :owasp_scorings do |t|
      t.integer :owasp_skill_level
      t.integer :owasp_motive
      t.integer :owasp_opportunity
      t.integer :owasp_size
      t.integer :owasp_awareness
      t.integer :owasp_intrusion_detection
      t.integer :owasp_ease_of_discovery
      t.integer :owasp_ease_of_exploit
      t.integer :owasp_loss_of_accountability
      t.integer :owasp_loss_of_availability
      t.integer :owasp_loss_of_confidentiality
      t.integer :owasp_loss_of_integrity
      t.integer :owasp_privacy_violation
      t.integer :owasp_non_compliance
      t.integer :owasp_financial_damage
      t.integer :owasp_reputation_damage
      t.timestamps
    end
  end
end
