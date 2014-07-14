ActiveAdmin.register Modular do
  menu :if => proc{ current_admin_user.present? }

  permit_params :model_name, :action_name, :section_id

  controller do
    before_filter :authenticate_admin_user!
    before_filter :check_subdomain
  end

  index do
    selectable_column
    column :model_name
    column :action_name
    actions
  end

  show do
    attributes_table :model_name, :action_name, :section
  end
end
