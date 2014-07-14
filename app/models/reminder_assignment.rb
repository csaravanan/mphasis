class ReminderAssignment < ActiveRecord::Base

	# Relationship
	has_many :reminders
end
