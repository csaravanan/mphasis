ActiveAdmin.register User do
  config.batch_actions = false
  menu :if => proc{ !current_admin_user.present? }


  breadcrumb do
    [
      link_to('Users', '/admin/users')
    ]
  end

  # removing delete option
  actions :all, :except => [:destroy]

  permit_params :full_name, :email, :user_name, :password , :password_confirmation, :role_id, :city, :state, :country_id,:is_disabled, :manager,  team_ids: [], profile_attributes: [:personal_email, :address2, :address1,  :city, :state, :country_id, :phone_no]

  controller do
    # removing delete option
    actions :all, :except => [:destroy]
    before_filter :check_company_admin, :check_role
    before_filter :check_subdomain
    def create
      @user = User.new(user_params)
      @user.company_id = current_user.company_id
      if @user.save
        team_id = params[:user][:team_ids].reject{|x| !x.present?}
        team_id.each do |team|
        user_team = UserTeam.where('user_id =? AND team_id =?',@user.id, team).first
        if user_team.nil?
          @user_team = UserTeam.new
          @user_team.team_id = team
          @user_team.user_id = @user.id
          @user_team.save
        end
end
	flash[:now] = MESSAGES["User"]["create"]["success"]
        redirect_to admin_users_path
      else
        # redirect_to new_admin_user_path
        render 'new'
      end
    end

    def update
      @user = User.find_by_id(params[:id])
      if @user.update(user_params)
        team_id = params[:user][:team_ids].reject{|x| !x.present?}
        team_id.each do |team|
        user_team = UserTeam.where('user_id =? AND team_id =?',@user.id, team).first
        if user_team.nil?
          @user_team = UserTeam.new
          @user_team.team_id = team
          @user_team.user_id = @user.id
          @user_team.save
        end
      end
        redirect_to admin_users_path
      else
        # redirect_to new_admin_user_path
        render 'new'
      end
    end

    private
      def user_params
        params.require(:user).permit(:full_name, :email, :user_name, :password , :password_confirmation, :is_disabled, :role_id,:company_id,:manager, team_ids: [], profile_attributes: [:personal_email, :address2, :address1, :phone_no, :city, :state, :country_id])
      end

      def scoped_collection
        current_company.users.where("role_id != ?",Role.where("title = 'company_admin'").first.id)
      end
  end

  index do
    selectable_column
    column :user_name
    column :email
    column :team do |team|
       team.teams.map(&:name).join(",")
    end
    column "Role" do |r|
      r.role_title
    end
    column :is_disabled
    actions
  end

  show do
    attributes_table do
      row :full_name
      row :email
      row :user_name
      row "Team" do |team|
        team.teams.map(&:name).join(",")
      end
      row "Role" do |r|
        r.role_title
      end
      row :is_disabled do |d|
        d.is_disabled? ? 'Yes': 'No'
      end
    end
  end


  form do |f|
    f.semantic_errors *[:"user_count_exceeds"]
    f.object.profile ? f.object.profile : f.object.build_profile
    f.inputs "User Details" do
      f.input :full_name
      if f.object.new_record?
        f.input :email
      else
        f.input :email, :input_html => { :disabled => true }
      end
      f.input :user_name
      f.input :teams, :class => "", :collection => current_company.teams
      f.input :role_id, :label => 'Role', :as => :select, :collection => current_company.roles, :prompt => "-Select Role-"
      f.input :manager , :label => 'Manager', :as => :select , :collection => current_company.users.map{|u| [u.display_name, u.id]}, :prompt => "-Select Manager-"
      f.input :is_disabled
    end
    f.inputs "Other Information", for: [:profile, f.object.profile] do |s|
      s.input :personal_email
      s.input :address1
      s.input :address2
      s.input :phone_no
      s.input :city
      s.input :state
      #~ s.input :country_id, :label => 'Country', :as => :select, :collection => Country.all, :prompt => "-Select Country-"
    end
    f.actions
   end
end