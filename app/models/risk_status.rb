class RiskStatus < ActiveRecord::Base

  #Assosciations
  has_many :risks

  scope :for_name, lambda {|name| where("name = (?)", name)}
end
