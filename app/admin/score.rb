ActiveAdmin.register Score do

  menu :if => proc{ current_admin_user.present? }

  #authentication
  controller do
    before_filter :authenticate_admin_user!
    before_filter :check_subdomain
  end

  # remove new record creation option
  actions :all, :except => [:new, :destroy]

  permit_params :id, :level, :description

  #display the required fields in index
  index do
    selectable_column
    column :level
    column :description
    actions
  end

  form do |f|
    f.inputs "Edit scores" do
      f.input :level, :input_html => { :disabled => true }
      f.input :description
    end
    f.actions
  end

end
