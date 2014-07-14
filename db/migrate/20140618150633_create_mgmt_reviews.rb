class CreateMgmtReviews < ActiveRecord::Migration
  def change
    create_table :mgmt_reviews do |t|
      t.integer :risk_id
      t.integer :review_id
      t.integer :reviewer
      t.integer :next_step_id

      t.timestamps
    end

    add_index :mgmt_reviews, :risk_id
    add_index :mgmt_reviews, :review_id
    add_index :mgmt_reviews, :reviewer
    add_index :mgmt_reviews, :next_step_id
  end
end
