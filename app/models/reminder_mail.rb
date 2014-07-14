class ReminderMail < ActiveRecord::Base

	
	# Method for Escalation Matrix
	def self.escalation_matrix(mail_type, mail_id, default_mail_count)
		remainder_mail = ReminderMail.find_or_create_by(mail_type: mail_type, mail_id: mail_id)
		remainder_mail.mail_count = remainder_mail.mail_count.to_i + 1
		remainder_mail.save
		if(default_mail_count < remainder_mail.mail_count)
		   return true
		end
		return false		
	end

end
