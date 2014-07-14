ActiveAdmin.register Role  do
 menu :if => proc{ !current_admin_user.present? }

  breadcrumb do
    [
      link_to('Roles', '/admin/roles')
    ]
  end

  permit_params :title, :company_id
 #authentication
  controller do
   before_filter :check_role, :check_company_admin
   before_filter :check_subdomain


    def scoped_collection
      current_company.roles.where.not(:title=> ["company_admin"])
    end

    def create
      role = Role.where("title= ? AND company_id= ?", params[:role][:title], current_user.company_id).first
      @role = Role.new(role_params)
      unless role.present?
        @role.company_id = current_user.company_id
        if @role.save
          @role.create_activity :create, owner: current_user
          flash[:now]=  MESSAGES["Role"]["create"]["success"]
          redirect_to admin_roles_path
        else
          render 'new'
        end
      else
        @role.errors.add(:title, MESSAGES["roles"]["company_admin_failure"])
        render 'new'
      end
		end

    private
      def role_params
        params.require(:role).permit(:title, :company_id)
      end
  end

  #display the required fields in index
  index  do
    column :title
    actions  do |f|
      link_to "Add privilege" , "/admin/privileges/new?role_id=#{f.id}"#, :onclick => "test();"
    end
  end


  form do |f|
    f.inputs "Roles" do
      f.input :title
    end
    f.actions
  end
end




