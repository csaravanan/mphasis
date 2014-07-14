ActiveAdmin.register Location do
  menu :if => proc{ !current_admin_user.present? }

    breadcrumb do
      [
        link_to('Location', '/admin/locations')
      ]
    end

  #authentication
  controller do
    before_filter :check_company_admin, :check_role
    before_filter :check_subdomain
  end

  permit_params :name, :company_id

  controller do
    #publicactivity gem
    include PublicActivity::StoreController

    def create
      @location = Location.new(location_params)
      @location.company_id = current_user.company_id
      if @location.save
        flash[:notice]=  MESSAGES["location"]["create"]["success"]
        redirect_to admin_locations_path
      else
        # flash[:error]=  MESSAGES["uniqueness"]["create"]["failure"]
       @errors = @location.errors
        # redirect_to new_admin_location_path
        render 'new'
    end

    end

    private
      def location_params
        params.require(:location).permit(:name, :company_id)
      end

      def scoped_collection
        current_company.locations
      end
  end

  index do
    selectable_column
    column :name
    actions
  end

  show do
    attributes_table :name, :company
  end

  form do |f|

       f.inputs "New Location" do
       f.input :name, :label => t('en.location.name')
       f.label :@errors if @errors.present?
    end
    f.actions
  end
end
