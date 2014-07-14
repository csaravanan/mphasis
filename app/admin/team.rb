ActiveAdmin.register Team do

  menu :if => proc{ !current_admin_user.present? }

  breadcrumb do
    [
      link_to('Teams', '/admin/teams')
    ]
  end


 controller do
    before_filter :check_company_admin, :check_role
    before_filter :check_subdomain
    action :all, except: [:new, :show]

    #publicactivity gem
    include PublicActivity::StoreController

    def scoped_collection
      current_company.teams
    end

    def create
      @team = Team.new(team_params)
      @team.company_id = current_user.company_id
      if @team.save
        flash[:now]=  MESSAGES["Team"]["create"]["success"]
        redirect_to admin_teams_path
      else
        # redirect_to new_admin_team_path
        render 'new'
      end
    end

    private
      def team_params
        params.require(:team).permit(:name, :module_id, :company_id, :department_id, :section_id)
      end
  end

  permit_params :name, :department_id, :section_id


  index do
    selectable_column
    column :name
    actions
  end

  show do
    attributes_table :name, :company, :department, :section
  end

  form do |f|
    f.inputs "New Team" do
      f.input :department_id, :label => 'Department', :as => :select, :collection => Department.where(:location_id=>current_company.locations.map(&:id)).map{ |u| ["#{u.location.try(:name)} / #{u.name}", u.id]}, :prompt => "-Select Department-"
      f.input :section_id, :label => 'Section', :as => :select, :collection => Section.all.map{ |u| [u.name, u.id]}, :prompt => "-Select Section-"
      f.input :name
    end
    f.actions
  end
end
