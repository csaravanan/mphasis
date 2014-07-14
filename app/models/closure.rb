class Closure < ActiveRecord::Base

	# Associations
	belongs_to :risk
	belongs_to :user
	belongs_to :close_reason

end
