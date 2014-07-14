class AuditCompliancesController < ApplicationController
    before_filter :current_audit, :company_module_access_check
    before_filter :authorize_auditees_skip_company_admin, :only => [:response, :response_checklist]
    before_filter :authorize_auditees, :only => [:submit]
    before_filter :check_for_auditee_response, only: [:index]
    before_filter :authorize_auditor_skip_company_admin, :only => [:index, :compliance_checklist]
    before_filter :authorize_auditor, :only => [:create]
  # List the compliance for particular audit - JSON grid
	def compliance_checklist
    @auditees = @audit.auditees
    @audit_compliances = @audit.audit_compliances
		@compliance_libraries = @audit.default_compliance_libraries
		@priorities = Priority.all
  end

  # Response List for audit compliance of particular audit - JSON grid
  def response_checklist
    @audit_compliances = @audit.audit_compliances_for_current_user(current_user.id)
    render json: {data: build_response_list}
  end

  # Create the Selected audit compliance for audit
  def create
    @audit.build_audit_compliance(compliance_params) unless(@audit.audit_status_id == 4)
  end

  # Submit the audit compliance to the recommendation
  def update
    @audit.audit_compliances.update_all(is_answered: true)  unless(@audit.audit_status_id == 4)
    redirect_to audits_path
  end

  private
  # Strong parameters audit compliance
  def compliance_params
    params.require(:checklist)
  end
  # Check for Auditee response and redirect accordingly
  def check_for_auditee_response
    if(@audit.auditees.map(&:id).include?(current_user.id))
      redirect_to response_audit_audit_compliances_path(@audit)
    end
  end
  # Json builder for response list.
  def build_response_list
    response = []
      @audit_compliances.each do |compliance|
        if(compliance.artifact_answers.present?)
          compliance.artifact_answers.each do |artifact_answer|
            json = artifact_answer.build_checklist(compliance)
            response << json
          end
        end
      end
      response
  end
end
