class Project < ActiveRecord::Base

	# Associations
  has_many :risks
	belongs_to :company
end
