class DashboardController < ApplicationController
	
	before_filter :company_module_access_check
	
  #Audit Calender Page
	def calender
		@audit = current_user.accessible_audits
	end

  # Main Dashboard page
  def index
  end
end
