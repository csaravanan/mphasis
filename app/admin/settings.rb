ActiveAdmin.register Company, { :as => 'Settings'} do
  menu :if => proc{ !current_admin_user.present? }

  breadcrumb do
    [
      link_to('Settings', '/admin/settings')
    ]
  end

  actions :all, :except => [:new, :create, :show, :destroy]
  config.filters = false
  config.batch_actions = false

  permit_params :name, :secondary_email, :address1, :address2, :country_id, :contact_no, :timezone, :is_disabled, :primary_email, attachment_attributes: [:id,:attachment_file, :company_id, :file_size, :_destroy]

  controller do
    before_filter :check_company_admin, :check_role
    before_filter :check_subdomain
    before_filter :authorize_company, only: [:edit, :update]
    def index
      redirect_to edit_admin_setting_path(current_user.company_id)
    end

    # def edit
    #   @company = current_user.company
    # end

    # def update
    # if @company.update_attributes(company_params)
    #   redirect_to edit_admin_setting_path(current_user.company_id)
    # else
    #   render :edit
    # end
    # end


    def authorize_company
      unless current_user.company_id == params[:id].to_i
        redirect_to root_subdomain_path
      end
    end
  end

  form do |f|
    f.object.build_attachment unless f.object.attachment.present?
    f.semantic_errors *[:"attachment.file_size_exceeds"]
    f.inputs "Company Details" do
      f.input :name
      f.input :primary_email
      f.input :secondary_email
      f.input :domain , :input_html => { :disabled => true }
      f.input :address1
      f.input :address2
      f.input :timezone, :as => :select, :collection => Company::TIMEZONES
      f.input :country
      f.input :contact_no
    end
    f.inputs "Attachments", for: [:attachment, f.object.attachment] do |s|
      s.input :attachment_file, :as => :file, :hint => s.template.image_tag(s.object.attachment_file.thumb) if s.object.attachment_file.present?
      s.input :attachment_file if s.object.attachment_file.blank?
      s.input :company_id, :as => :hidden, :input_html => { :value => current_company.id}
      s.input :_destroy, as: :boolean, required: :false, label: 'Remove image' if s.object.attachment_file.present?
    end
    f.actions
  end
end