json.data do |json|
 current_company_id = current_company.id
	json.array!(@compliance_libraries) do |compliance|
    if(audit_complince = @audit_compliances.find{|x| x.compliance_library_id == compliance.id})
      artifact_answers = audit_complince.artifact_answers.first
      json.id compliance.id
      json.already_selected "true"
      json.name compliance.name
      json.artifact_answers audit_complince.artifact_answers.map(&:id)
      json.artifacts audit_complince.artifacts.map(&:id)
      json.priority (artifact_answers ? artifact_answers.priority_id : "")
      json.auditee (artifact_answers ? artifact_answers.responsibility_id : "")
      json.target_date (artifact_answers ? (artifact_answers.target_date.present? ? artifact_answers.target_date.to_date.strftime("%d/%m/%Y") : "")  : "")
      json.priority_list @priorities.map{ |f| [f.id,f.name]}
      json.auditee_list @auditees.map{ |f| [f.id,f.user_name]}
      json.artifacts_list compliance.artifact_lists(current_company_id).map{ |f| [f.id,f.name]}
    else
      json.id compliance.id
      json.name compliance.name
      json.artifact_answers ""
      json.already_selected ""
      json.artifacts ""
      json.priority ""
      json.auditee ""
      json.target_date ""
      json.artifacts_list compliance.artifact_lists(current_company_id).map{ |f| [f.id,f.name]}
      json.priority_list @priorities.map{ |f| [f.id,f.name]}
      json.auditee_list @auditees.map{ |f| [f.id,f.user_name]}
    end
	end
end