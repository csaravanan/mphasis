class RiskReviewLevel < ActiveRecord::Base

  # Associations
  belongs_to :company
  
  scope :review_level, lambda {|name, company_id| where(name: name, company_id: company_id)}

end
