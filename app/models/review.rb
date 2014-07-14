class Review < ActiveRecord::Base

	# Relationships
	has_many :mgmt_reviews, dependent: :destroy

end
