ActiveAdmin.register Artifact do

    breadcrumb do
      [
        link_to('Artifact', '/admin/artifacts')
      ]
    end

    menu :if => proc{ !current_admin_user.present? }

    controller do
      before_filter :check_company_admin, :check_role, :check_subdomain, :company_admin_module_check
    end

    permit_params :compliance_library_id, :name

    index do
      column "Compliance library" do |c|
        c.compliance_library.try(&:name)
      end
      column :name
      actions
    end

    form do |f|
      all_compliance = ComplianceLibrary.where(:is_leaf => true)
      f.inputs "Artifacts" do
        f.input :compliance_library_id , :label => 'Control', :as => :select, :collection => all_compliance, :prompt => "-Select Control-"
        f.input :name
      end
      f.actions
    end

  controller do
    def create
      @artifact = Artifact.new(artifact_params)
      @artifact.company_id = current_user.company_id
      if @artifact.save
        redirect_to admin_artifacts_path
      else
        render 'new'
      end
    end

    private

    def artifact_params
      params.require(:artifact).permit(:compliance_library_id, :name ,:company_id)
    end

    def scoped_collection
      current_company.artifacts
    end
  end
end
