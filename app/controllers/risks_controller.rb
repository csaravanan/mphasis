class RisksController < ApplicationController
  before_filter :risk_users, only: [:new, :create, :edit, :update]
  before_filter :company_module_access_check
  layout 'risk_layout'

  def index
    if params[:stage].present?
      @risks = current_user.risks_stage(params)
    else
      @risks = current_user.accessible_risks
    end
    @high_risk, @medium_risk, @low_risk = Risk.risk_rating(current_company.id)
  end

  def new
    @risk = Risk.new
  end

  def create
    @risk = current_company.risks.new(risk_params)
    @risk.submitted_by = current_user.id
    @risk.set_risk_status(@risk, params[:commit])
    if @risk.save
      redirect_to risks_path, :flash => { :notice => MESSAGES["risk"]["create"]["success"]}
    else
      risk_initializers(@risk.location_id, @risk.department_id, @risk.team_id, @risk.compliance_id)
      render 'new'
    end
  end

  def edit
    @risk = Risk.find(params[:id])
    risk_initializers(@risk.location_id, @risk.department_id, @risk.team_id, @risk.compliance_id)
  end

  def update
    @risk = Risk.find(params[:id])
    @risk.set_risk_status(@risk, params[:commit]) if params[:commit] == "File Risk"
    if @risk.update_attributes(risk_params)
      redirect_to edit_risk_path, :flash => { :notice => MESSAGES["risk"]["update"]["success"]}
    else
      risk_initializers(@risk.location_id, @risk.department_id, @risk.team_id, @risk.compliance_id)
      render 'edit'
    end
  end

  def risk_imports
    if(params[:file].present?)
      begin
        Risk.import_from_file(params[:file], current_company, current_user)
        flash[:notice] = MESSAGES["risk"]["csv_upload"]["success"]
        redirect_to risks_path
      rescue
        flash[:notice]=  MESSAGES["csv_upload"]["error"]
        redirect_to new_risk_path
      end
    else
      flash[:notice]=  MESSAGES["csv_upload"]["presence"]
      redirect_to new_risk_path
    end
  end

  def risk_export
    begin
      file_to_download = "sample_risk.csv"
      send_file Rails.public_path + file_to_download, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=#{file_to_download}", :stream => true, :buffer_size => 4096
    rescue
      flash[:error] = MESSAGES["csv_export"]["error"]
      redirect_to new_risk_path
    end
  end

  def department_teams_users
    risk_initializers(params[:location_id], params[:department_id], params[:team_id], params[:compliance_id])
  end

  def download_risk_document
    attachment = Attachment.find(params[:id])
    send_file(Rails.public_path.to_s + attachment.attachment_file_url)
  end

  def remove_attachment
    attachment = Attachment.find(params[:id])
    attachment.delete
  end

  protected
    def risk_initializers(location_id = nil, department_id = nil, team_id = nil, compliance_id = nil)
      @compliance_libraries = ComplianceLibrary.for_id_and_leaf(compliance_id) if compliance_id
      @departments = Department.for_location(location_id) if location_id
      section = Section.by_name('Risk').first
      @teams = Team.for_department_and_company(department_id, current_company.id, section.id) if department_id
      @team_users = Team.for_id(team_id).first.users << current_company.company_admin if team_id
    end

  private
    def risk_params
      params.require(:risk).permit(:subject, :control_number, :reference, :compliance_id, :location_id, :category_id, :team_id, :technology_id, :owner, :assessment, :notes, :compliance_library_id, :department_id, :mitigator, :reviewer, :risk_model_id, attachment_attributes: [:id, :attachment_file, :company_id], risk_scoring_attributes:[:scoring_type, :custom_value, scoring_attributes: [:likelihood, :impact, :vulnerability, :velocity, :owasp_skill_level, :owasp_motive, :owasp_opportunity, :owasp_size, :owasp_ease_of_discovery, :owasp_ease_of_exploit, :owasp_awareness, :owasp_intrusion_detection, :owasp_loss_of_confidentiality, :owasp_loss_of_integrity, :owasp_loss_of_availability, :owasp_loss_of_accountability, :owasp_financial_damage, :owasp_reputation_damage, :owasp_non_compliance, :owasp_privacy_violation, :dread_damage_potential,  :dread_reproducibility,  :dread_exploitability,  :dread_affected_users,  :dread_discoverability, :cvss_access_vector,  :cvss_access_complexity,  :cvss_authentication,  :cvss_conf_impact,  :cvss_integ_impact,  :cvss_avail_impact,  :cvss_exploitability,  :cvss_remediation_level,  :cvss_report_confidence,  :cvss_collateral_damage_potential,  :cvss_target_distribution,  :cvss_confidentiality_requirement,  :cvss_integrity_requirement,  :cvss_availability_requirement]])
    end

    def risk_users
      @mitigator_role = Role.for_title_by_company("mitigator", current_company.id).first
      @mitigator_users = current_company.users.where(role_id: @mitigator_role.id) if @mitigator_role

      @reviewer_role = Role.for_title_by_company("reviewer", current_company.id).first
      @reviewer_users = current_company.users.where(role_id: @reviewer_role.id) if @reviewer_role
    end
end
