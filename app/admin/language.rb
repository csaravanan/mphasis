ActiveAdmin.register Language do

  menu :if => proc{ current_admin_user.present? }

  permit_params :name, :code

  controller do
    before_filter :authenticate_admin_user!
    before_filter :check_subdomain
  end

  index do
    selectable_column
    column :name
    column :code
    actions
  end

  show do
    attributes_table :name, :code
  end

end
