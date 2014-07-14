ActiveAdmin.register Client do

  breadcrumb do
    [
      link_to('Client', '/admin/clients')
    ]
  end

  menu :if => proc{ !current_admin_user.present? }

  permit_params :name, :company_id, :address1, :address2, :contact_no, :email

  controller do
    before_filter :check_company_admin, :check_role
    before_filter :check_subdomain
    action :all, except: [:new, :show]

    #publicactivity gem
    include PublicActivity::StoreController

    def scoped_collection
      current_company.clients
    end

    def create
      @client = Client.new(client_params)
      @client.company_id = current_user.company_id
      if @client.save
        flash[:notice]=  MESSAGES["client"]["create"]["success"]
        redirect_to admin_clients_path
      else
        # flash[:error]=  MESSAGES["uniqueness"]["create"]["failure"]
        #render new_admin_client_path
        render 'new'
      end
    end

    private
      def client_params
        params.require(:client).permit(:name, :company_id, :address1, :address2, :contact_no, :email)
      end
  end
   #authentication


  index do
    selectable_column
    column :name
    column :address1
    column :address2
    column :contact_no
    column :email
    actions
  end

  form do |f|
    # f.semantic_errors *f.object.errors.keys
    f.inputs "Clients Details" do
      f.input :name
      f.input :address1
      f.input :address2
      f.input :contact_no
      f.input :email
    end
    f.actions
  end
end
