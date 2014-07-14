ActiveAdmin.register Project do
  
  menu :if => proc{ !current_admin_user.present? }
  breadcrumb do
    [
      link_to('Projects', '/admin/projects')
    ]
  end
  
  permit_params :name, :order, :company_id
  
  controller do
    before_filter :check_company_admin, :check_role, :company_admin_module_check, :check_subdomain
   action :all, except: [:new, :show]

    def scoped_collection
      current_company.projects
    end
    
  end
  
  #Index page fields customization
  index do
    column :name
    column :order
    actions
  end
  
  #show page fields customization
  show do
    attributes_table do
      row :id
      row :name
      row :order
    end
  end
  
  form do |f|
      f.inputs "New Project" do
      f.input :name
      f.input :order
      f.input :company_id, :as => :hidden, :input_html => { :value => current_company.id}
    end
    f.actions
  end
end
