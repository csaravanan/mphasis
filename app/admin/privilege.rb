ActiveAdmin.register Privilege do
	#To change title bar link
  breadcrumb do
    [
      link_to('Roles', '/admin/roles')
    ]
  end

  menu :if => proc{ !current_admin_user.present? }
	#To hide form menu
	menu false

	controller do
    before_filter :authenticate_user!, :check_company_admin, :check_role
    before_filter :check_subdomain
	  #~ skip_before_filter :verify_authenticity_token
	  before_filter :role_company, only: [:new]

  	def scoped_collection
  		Privilege.where(role_id: current_company.roles.map(&:id))
  	end

		#To crete new previlege
    def create
		 	@created_priviliges = []
		 	@privileges_create = true
			params[:privilege][:modular_id] && params[:privilege][:modular_id].each do |privilege_modular_id|
				@privilege =  Privilege.where('role_id =? AND modular_id =?', params[:privilege][:role_id], privilege_modular_id).first
				if @privilege.nil?
					@privilege = Privilege.new(privilege_params)
					@privilege.modular_id = privilege_modular_id
					@privilege.save
					@created_priviliges << @privilege
		    else
		    	@privileges_create = false
				end
			end
			respond_to :js
		end

		def edit
			@privilege = Privilege.where('id= ?', params[:id]).first
			@section = ["Audit"]
			@role_privilege = Privilege.where('role_id= ?', @privilege.role_id)
		end

		def role_privileges
			role = Role.where(id: params[:role_id]).first
			@privileges = role.privileges
		end

		def update
			params[:privilege][:modular_id].reject(&:empty?).each do |controller_name|
  			modular_id = Modular.where('modal_name =?', controller_name).first.id
  			@privilege = Privilege.where('role_id =? AND modular_id =?',  params[:privilege][:role_id], modular_id).first
    		if @privilege.nil?
    			Privilege.create(:role_id => params[:privilege][:role_id], :modular_id => modular_id)
    		end
  	  end
    end

		def destroy
			privilege = Privilege.where('id= ?', params[:id]).first
			privilege.destroy if privilege.present?
			respond_to :js
		end

		#To get modular record based on section select
		def  modal_previlege
			modular_id = Modular.where('section_id =?', params[:modal_id])
			render json: {:actions=>modular_id}
		end

		private

      def privilege_params
        params.require(:privilege).permit(:role_id, modular_id: [])
	    end

			#To check company roles for previleges
		  def role_company
  			if current_user.company.roles.collect {|x| x.id}.include?(params[:role_id].to_i)
  				return true
  			else
  				redirect_to admin_roles_path
  			end
		  end
	end



	#display the required fields in index
  index do
    column :role_id
    actions
  end

	#render form for create & edit previleges
	form :partial => "form"
end
