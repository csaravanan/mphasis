class CloseReason < ActiveRecord::Base

	# Associations
	has_many :closures, dependent: :destroy
end
