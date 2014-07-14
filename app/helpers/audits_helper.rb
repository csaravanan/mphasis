module AuditsHelper

	def standard_name(audit)
		if audit.compliance_type == 'Compliance'
			compliance = Compliance.where('id= ?', audit.standard_id).first
			compliance.name  unless compliance.nil?
		else
			topic = Topic.where('id= ?', audit.standard_id).first
			topic.name unless topic.nil?
		end
	end
	
	def  dashboard_audit_status(audit_status_id, status)
		id = AuditStatus.where('name= ?', status).first.try(&:id)
		if id.present?
			if audit_status_id == id
				'a_drakgreen'
			elsif audit_status_id > id
				'a_lightgreen'
			else
				'a_grey'
			end
		end
	end

	def check_non_compliance_type(audit,errors)
		return true if (audit.compliance_type == 'NonCompliance' && (errors[:standard_id].present? || audit.standard_id.present?))
	end

	def check_compliance_type(audit,errors)
		return true if (audit.compliance_type == 'Compliance' && (errors[:standard_id].present? || audit.standard_id.present?))
	end


end
