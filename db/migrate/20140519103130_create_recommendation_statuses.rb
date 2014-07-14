class CreateRecommendationStatuses < ActiveRecord::Migration
  def change
    create_table :recommendation_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end