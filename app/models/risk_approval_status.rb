class RiskApprovalStatus < ActiveRecord::Base

  # Associations
  has_many :risks, dependent: :destroy
end
