class SkippedAuditReminder < ActiveRecord::Base

	# Relationship
	belongs_to :audit
	belongs_to :user

	def self.audits
		SkippedAuditReminder.all.map(&:audit)
	end
end
