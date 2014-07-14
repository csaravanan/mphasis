module ChecklistRecommendationsHelper

	# def audit_checklist(control, audit_id)
	# 	@audit_compliance = AuditCompliance.where('compliance_library_id= ? AND audit_id= ?',control.id, audit_id).first
	# 	@audit_compliance.checklist_recommendations.first if @audit_compliance
	# end

	# def checklist_control(checklist)
	# 	checklist.checklist.compliance_library
	# end
	
	# def audit_compliance_id(control_id, audit_id)
	# 	AuditCompliance.where('compliance_library_id= ? AND audit_id= ?',control_id,audit_id).first.id
	# end

	def recommendation_status
		closed = RecommendationStatus.where('name= ?','Closed Recommendation').first.id
		closed_duplicate = RecommendationStatus.where('name= ?','Closed duplicate Recommendation').first.id
		risk_accepted = RecommendationStatus.where('name= ?','Risk accepted for Recommendation').first.id
		return closed, closed_duplicate, risk_accepted
	end
	
	def audit_status
		AuditStatus.where('name= ?', 'Published').first.id
	end
	
	def audit_response_status
		ResponseStatus.where('name= ?', 'Completed').first.id
	end
end
