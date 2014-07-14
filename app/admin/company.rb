ActiveAdmin.register Company do

  menu :if => proc{ current_admin_user.present? }
  #authentication
  controller do
    before_filter :authenticate_admin_user!
    before_filter :check_subdomain
  end
  # Remove new company creation option from ActiveAdmin
  actions :all, :except => [:new, :destroy]

  index do
    column :name
    column :primary_email
    column :domain
    column :timezone
    column :country
    column :contact_no
    column :is_disabled
    column  "Subscription" do |c|
      c.subscriptions.first.try(&:name)
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :primary_email
      row :secondary_email
      row :domain
      row :address1
      row :address2
      row :timezone
      row :country
      row :contact_no
      row "Subscription" do |c|
        c.subscriptions.first.try(&:name)
      end
      row :is_disabled
   end
  end

  form do |f|
    f.inputs "Company Details" do
      f.input :name
      f.input :primary_email
      f.input :secondary_email
      f.input :domain , :input_html => { :disabled => true }
      f.input :address1
      f.input :address2
      f.input :timezone
      f.input :country
      f.input :contact_no
      f.input :is_disabled
    end
    f.inputs "Plan", for: [:plan, f.object.plan] do |s|
      s.input :expires, :as => :datepicker
      s.input :subscription_id, as: :select, :collection => Subscription.all, :prompt => "-Select Subscription-"
    end
    f.actions
  end

  permit_params :name, :primary_email, :secondary_email, :domain, :address1, :address2, :timezone, :country_id, :contact_no, :is_disabled, subscription_ids: [], plan_attributes: [:id,:subscription_id, :company_id, :starts, :expires]
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
end