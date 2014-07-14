ActiveAdmin.register CppMeasure, { :as => 'Procedures'} do

  
  menu :if => proc{ !current_admin_user.present? }
  
  breadcrumb do
    [
      link_to('Procedures', '/admin/procedures')
    ]
  end
  
  permit_params :compliance_id, :name, :description, :duration, :measure_type, :company_id
  
 controller do
    before_filter :check_company_admin, :check_role, :company_admin_module_check, :check_subdomain
   action :all, except: [:new, :show]

    def scoped_collection
      CppMeasure.where('measure_type= ? AND company_id= ?','Procedure',current_company)
    end
    
  end
  
  #Index page fields customization
  index do
    column :name
    column :description
    column :compliance
    actions
  end
  
  #show page fields customization
  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :compliance
      row :created_at
      row :updated_at
    end
  end
  
  form do |f|
      f.inputs "New Procedures" do
      f.input :name
      f.input :description
      f.input :compliance_id, :label => 'Regulation', :as => :select, :collection => Compliance.all, :prompt => "-Select Regulation-"
      f.input :implementation_status_id, :label => 'Implementation Status', :as => :select, :collection => ImplementationStatus.all, :prompt => "-Select Status-"
      f.input :measure_type, :as => :hidden, :input_html => { :value => "Procedure"}
      f.input :company_id, :as => :hidden, :input_html => { :value => "#{current_company.id}"}
    end
    f.actions
  end
end
