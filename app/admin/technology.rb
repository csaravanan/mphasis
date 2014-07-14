ActiveAdmin.register Technology do

   menu :if => proc{ !current_admin_user.present? }
  
  breadcrumb do
    [
      link_to('Technology', '/admin/technologies')
    ]
  end
  
  permit_params :name, :company_id
  
  controller do
    before_filter :check_company_admin, :check_role
    before_filter :check_subdomain
   action :all, except: [:new, :show]

    def scoped_collection
      current_company.technologies
    end
    
  end
  
  #Index page fields customization
  index do
    column :name
    actions
  end
  
  #show page fields customization
  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end
  end
  
    form do |f|
      f.inputs "New Technology" do
        f.input :name
      f.input :company_id, :as => :hidden, :input_html => { :value => current_company.id}
    end
    f.actions
  end
end
