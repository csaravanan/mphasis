class BaseController < ActionController::Base

  protected

  # will check for sudomain presence and correct subdomain
  def check_subdomain
    if(request.subdomain.present? || current_company.present?)
      current_company.present? ? check_current_company_domain : (redirect_to current_path_without_subdomain)
    end
  end

  # Escape the subdomain from the given url
  def escape_subdomain
    if(request.subdomain.present?)
      redirect_to current_path_without_subdomain
    end
  end

# Escape the subdomain if there is no company
  def escape_subdomain_with_company
    if(request.subdomain.present? && !Company.where(domain: request.subdomain).present?)
      redirect_to current_path_without_subdomain
    end
  end

  # Checks whether current domain matches the logged_in company domain
  def check_current_company_domain
    unless(current_company.domain.eql?(request.subdomain))
      redirect_to current_path_with_subdomain
    end
  end

  # Set Locale for selected Language
  def set_locale
      I18n.locale  = current_user.language_id.present? ? ::Language.current_user_language(current_user.language_id).first.code : I18n.default_locale
      MESSAGES.replace ::ALLMESSAGES["#{I18n.locale}"]
  end

  # Returns URL with subdomain.. Call this function after User logged_in areas
  def current_path_with_subdomain
    request.protocol + current_company.domain + "." + request.domain + (request.port.nil? ? '' : ":#{request.port}") + request.fullpath
  end

    # Find Audit
  def current_audit
    @audit = Audit.find(params[:audit_id])
    authorize!(:read,  @audit)
  end

  def current_risk
    @risk = Risk.find(params[:risk_id])
  end

  def current_audit_with_id
    @audit = Audit.find(params[:id])
    authorize!(:read,  @audit)
  end

 # Returns URL with subdomain.. Call this function after User logged_in areas
  def root_subdomain_path
    request.protocol + current_company.domain + "." + request.domain + (request.port.nil? ? '' : ":#{request.port}")
  end

  # Returns URL without subdomain..
  def current_path_without_subdomain
    "http://" + request.domain + (request.port.nil? ? '' : ":#{request.port}") + request.fullpath
  end

  # Set TimeZone based upon the user and thier company
  def set_time_zone
    case current_user.timezone || current_company.timezone
    when current_user.timezone
      Time.zone = current_user.timezone
    when current_company.timezone
      Time.zone = current_company.timezone
    else
      Time.zone = "Mumbai"
    end
  end

  # check for company disable status
  def check_company_disabled
     if current_company.is_disabled == true
      sign_out current_user
      redirect_to root_path
    end
  end

  #To check company admin
    def check_company_admin
      if(!current_user || current_company.id != current_user.company_id)
        flash[:alert] = "Access restricted"
        redirect_to '/users/sign_in'
      end
    end

  # Check role for compnay admin and Authenticate thier Active admin
  def check_role
    role = current_user.role_title
    if role == 'company_admin'
      return true
    else
      flash[:alert] = "Access restricted"
      redirect_to '/users/sign_in'
    end
  end

  # set audit Cookie as Last audit, if current audit is not present
  def set_cookie_audit
    unless cookies[:audit_id].present?
      cookies[:audit_id] = { :value => current_user.accessible_audits.last.id, :expires => 24.hour.from_now } if current_user.accessible_audits.present?
    end
  end

  # Authorize the Auditor for current audit
  def authorize_auditor
	  	unless @audit.auditor == current_user.id
        flash[:alert] = "Access restricted"
	  		redirect_to audits_path
	  	end
  end

  # Authorize the Auditee for current audit
	def authorize_auditees
	  	unless @audit.auditees.map(&:id).include?(current_user.id)
        flash[:alert] = "Access restricted"
	  		redirect_to audits_path
	  	end
	end
  # Authorize the Auditor for current audit and Skip current admin alone
  def authorize_auditor_skip_company_admin
	  	if(@audit.auditor != current_user.id && current_user.role_title != "company_admin")
        flash[:alert] = "Access restricted"
	  		redirect_to audits_path
	  	end
  end

  # Authorize the Auditee for current audit and Skip current admin alone
	def authorize_auditees_skip_company_admin
	  if(!@audit.auditees.map(&:id).include?(current_user.id) && current_user.role_title != "company_admin")
	    flash[:alert] = "Access restricted"
	  		redirect_to audits_path
	  	end
	end

end
