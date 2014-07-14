class OwaspScoring < ActiveRecord::Base
	
	has_one :risk_scoring , as: :scoring
	
end
