class PlanningStrategy < ActiveRecord::Base

  has_many :mitigations, dependent: :destroy

end
