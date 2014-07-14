class MitigationsController < ApplicationController
  layout "risk_layout"
  before_filter :current_risk#, :company_module_access_check

  before_filter :authorize_mitigation, :only => [:new, :create, :edit, :update]

  def index
  end

  def new
    if(@risk.mitigation.present?)
      redirect_to edit_risk_mitigation_path(risk_id: @risk.id, id: @risk.mitigation.id)
    else
      @risk.build_mitigation
      @risk.build_control_measure
    end
  end

  def create
    if @risk.update(mitigation_params)
      @risk.update_risk_scoring(@risk)
      flash[:notice] = "mitigation saved"
      @risk.update(risk_status_id: RiskStatus.where("name= ?", "Mitigated").first.id )
      redirect_to edit_risk_mitigation_path(risk_id: @risk.id, id: @risk.mitigation.id)
    else
      render "new"
    end
  end

  def edit
    redirect_to new_risk_mitigation_path(risk_id: @risk.id) unless @risk.mitigation.present?
  end

  def update
    if @risk.update(mitigation_params)
      @risk.update_risk_scoring(@risk)
       #@risk.risk_scoring.scoring.update(mitigation_params["scoring"])
      flash[:notice] = "mitigation saved"
      @risk.update(risk_status_id: RiskStatus.where("name= ?", "Mitigated").first.id )
      redirect_to edit_risk_mitigation_path(risk_id: @risk.id, id: @risk.mitigation.id)
    else
      render "edit"
    end
  end

private

 def mitigation_params
    params.require(:risk).permit(mitigation_attributes:[ :id, :risk_id, :planning_strategy_id, :mitigation_effort_id, :current_solution, :security_requirements, :security_recommendations, :submitted_by], control_measure_attributes: [:id, :risk_id, {control_ids: []}, :threat, :consequence, :effectiveness, :risk_scoring_id, {process_ids: []}, {procedure_ids: []}] ,risk_scoring_attributes:[:id, :scoring_type, :custom_value, scoring_attributes: [:id, :likelihood, :impact, :velocity, :vulnerability, :owasp_skill_level, :owasp_motive, :owasp_opportunity, :owasp_size, :owasp_awareness, :owasp_intrusion_detection, :owasp_ease_of_discovery, :owasp_ease_of_exploit, :owasp_loss_of_accountability, :owasp_loss_of_availability, :owasp_loss_of_confidentiality, :owasp_loss_of_integrity, :owasp_privacy_violation, :owasp_non_compliance, :owasp_financial_damage, :owasp_reputation_damage, :cvss_access_vector, :cvss_access_complexity, :cvss_authentication, :cvss_conf_impact, :cvss_integ_impact, :cvss_avail_impact, :cvss_exploitability, :cvss_remediation_level, :cvss_report_confidence, :cvss_collateral_damage_potential, :cvss_target_distribution, :cvss_confidentiality_requirement, :cvss_integrity_requirement, :cvss_availability_requirement, :dread_damage_potential, :dread_reproducibility, :dread_exploitability, :dread_affected_users, :dread_discoverability]])
 end


  def authorize_mitigation
    if ((current_risk.mitigator != current_user.id) && (current_risk.submitted_by != current_user.id))
      flash[:alert] = "Access restricted"
      redirect_to risks_path
    end
  end
end
