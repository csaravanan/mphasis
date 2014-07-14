class CreateChecklistRecommendations < ActiveRecord::Migration
  def change
    create_table :checklist_recommendations do |t|
      t.integer :checklist_id
      t.string :checklist_type
      t.integer :auditee_id
      t.text :recommendation
      t.text :reason
      t.text :corrective
      t.text :preventive
      t.date :closure_date
      t.integer :recommendation_priority_id
      t.integer :recommendation_severity_id
      t.integer :response_priority_id
      t.integer :response_severity_id
      t.integer :recommendation_status_id
      t.integer :response_status_id
      t.integer :dependent_recommendation
      t.integer :blocking_recommendation
      t.text :observation
      t.boolean :is_implemented, :default => false
      t.boolean :recommendation_completed, :default => false
      t.boolean :response_completed, :default => false


      t.timestamps
    end

    add_index :checklist_recommendations, :checklist_id
    add_index :checklist_recommendations, :auditee_id
    add_index :checklist_recommendations, :recommendation_priority_id
    add_index :checklist_recommendations, :recommendation_severity_id
    add_index :checklist_recommendations, :response_priority_id
    add_index :checklist_recommendations, :response_severity_id
    add_index :checklist_recommendations, :recommendation_status_id
    add_index :checklist_recommendations, :response_status_id
    add_index :checklist_recommendations, :dependent_recommendation
    add_index :checklist_recommendations, :blocking_recommendation

    add_index :checklist_recommendations, :checklist_type

  end
end
