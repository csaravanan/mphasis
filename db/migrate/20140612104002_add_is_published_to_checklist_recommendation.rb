class AddIsPublishedToChecklistRecommendation < ActiveRecord::Migration
  def change
    add_column :checklist_recommendations, :is_published, :boolean
  end
end
