class DreadScoring < ActiveRecord::Base

	has_one :risk_scoring , as: :scoring


end
