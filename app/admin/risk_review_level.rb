ActiveAdmin.register RiskReviewLevel do

  menu :if => proc{ !current_admin_user.present? }
  actions :all, :except => [:new]
  breadcrumb do
    [
      link_to('Review Levels', '/admin/risk_review_levels')
    ]
  end
  
  permit_params :name, :days, :company_id, :value
  
  controller do
    before_filter :check_company_admin, :check_role, :company_admin_module_check, :check_subdomain
   action :all, except: [:new, :show]

    def scoped_collection
      current_company.risk_review_levels
    end
    
  end
  
  #Index page fields customization
  index do
    column :name
    column :days
    column :value
    actions
  end
  
  #show page fields customization
  show do
    attributes_table do
      row :id
      row :name
      row :days
      row :value
    end
  end
  
  form do |f|
     review = RiskReviewLevel.find_by_id(params[:id])
      f.inputs "New Risk Review Level" do
      f.input :days, :label => "I want to review #{review.name} risk in days", :input_html => { :style => "width: 10%; margin:0px 0 0 50px; display:block;"}
      f.input :value, :label => "I consider #{review.name} risk to be anything greater than: ", :input_html => { :style => "width: 10%; margin:0px 0 0 50px; display:block;"}
      f.input :company_id, :as => :hidden, :input_html => { :value => current_company.id}
    end
    f.actions
  end
end
