class CreateRisks < ActiveRecord::Migration
  def change
    create_table :risks do |t|
      t.string :subject
      t.integer :compliance_library_id
      t.text :assessment
      t.text :notes
      t.integer :risk_status_id
      t.string :reference
      t.integer :compliance_id
      t.integer :location_id
      t.integer :category_id
      t.integer :department_id
      t.integer :team_id
      t.integer :technology_id
      t.integer :owner
      t.integer :mitigator
      t.integer :reviewer
      t.date :review_date
      t.integer :project_id
      t.integer :submitted_by
      t.integer :risk_approval_status_id
      t.integer :company_id
      t.integer :risk_model_id

      t.timestamps
    end

    add_index :risks, :risk_status_id
    add_index :risks, :compliance_id
    add_index :risks, :compliance_library_id
    add_index :risks, :location_id
    add_index :risks, :category_id
    add_index :risks, :department_id
    add_index :risks, :team_id
    add_index :risks, :technology_id
    add_index :risks, :owner
    add_index :risks, :mitigator
    add_index :risks, :reviewer
    add_index :risks, :project_id
    add_index :risks, :submitted_by
    add_index :risks, :risk_approval_status_id
    add_index :risks, :company_id
    add_index :risks, :risk_model_id
  end
end












