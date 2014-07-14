ActiveAdmin.register Subscription do
menu :if => proc{ current_admin_user.present? }
  #authentication
  controller do
    before_filter :authenticate_admin_user!
    before_filter :check_subdomain

    def create
      params[:subscription][:section_ids] = params[:subscription][:section_ids].reject{|x| !x.present?}
      @subscription = Subscription.new(params[:subscription])
      if @subscription.save         
        redirect_to admin_subscriptions_path
      else
        render "new"
      end
    end

    def update
      params[:subscription][:section_ids] = params[:subscription][:section_ids].reject{|x| !x.present?}
       @subscription = Subscription.where("id = ?",params[:id]).first
      if @subscription.update_attributes(params[:subscription])      
        redirect_to admin_subscriptions_path
      else
        render "new"
      end
    end

    private

    def subscription_params
      params.require(:subscription).permit(:name,:description,{:section_ids =>[]},:amount, :valid_log,:valid_period,:user_count,:file_size)
    end

  end

  index do
    column :name
    column :description
    column "Section" do |c|
      Section.where("id IN (?)",c.section_ids).map(&:name).join(",")
    end
    column :amount
    column :valid_log
    column "Valid Period" do |c|
      "Month(s)"
    end
    column :user_count
    column :file_size 
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row "Section" do |sec|     
       Section.where("id IN (?)",sec.section_ids).map(&:name).join(",")
      end
      row :amount
      row :valid_log
      row "Valid Period" do |c|
        "Month(s)"
      end
      row :user_count
      row :file_size
      end
  end

  form do |f|

       f.inputs "New Subscription" do
       f.input :section_ids, label: 'Section', as: :select,multiple: true,collection: Section.all.collect{|x| [x.name,x.id]},prompt: "--Select Section--"
       f.input :name
       f.input :description
       f.input :amount
       f.input :valid_log
       f.input :valid_period,:input_html=>{:value=>"Month(s)",:disabled =>true}
       f.input :user_count
       f.input :file_size
      end
    f.actions
  end

end