ActiveAdmin.register Plan do
   menu :if => proc{ !current_admin_user.present? }

  actions :all, :except => [:new,:destroy]


  controller do
    actions :all, :except => [:new,:destroy]
    before_filter :check_company_admin, :check_role
    before_filter :check_subdomain

    def scoped_collection
      Plan.where("company_id = ?",current_company.id )
    end

    def update
      plan = Plan.where("id = ?", params[:id]).first
     if !current_company.subscriptions.first.id.eql?(params[:plan][:subscription_id]) && plan.expires.to_date <= Date.today
      subscribe = Subscription.where("id = ?",params[:plan][:subscription_id]).first
      if subscribe.amount.eql?(0.0)         
         plan.update_attributes(subscription_id: subscribe.id ,company_id: current_company.id)
         plan.update_attributes(starts: plan.updated_at ,expires: calculate_plan_expiration(subscribe.valid_log,plan.updated_at))
         redirect_to admin_plans_path
        else
          redirect_to new_transaction_path(company: current_company.name,subscription: subscribe.name)
      end
    else
      redirect_to admin_plans_path
    end
    end

  end

   index do
    column "Subscription" do |c|
      Subscription.where("id = ? ",c.subscription_id).map(&:name).join(",")
    end
    column "Amount" do |c|
      Subscription.where("id IN (?)",c.subscription_id).map(&:amount).join(",")
    end
    column "Company" do |c|
      Company.where("id = ?",c.company_id).map(&:name).join(",")
    end    
    column :starts
    column :expires

    actions
  end
 
  show do
    attributes_table do
    row "Subscription" do |c|
      Subscription.where("id = ? ",c.subscription_id).map(&:name).join(",")
    end    
    row "Amount" do |c|
      Subscription.where("id IN (?)",c.subscription_id).map(&:amount).join(",")
    end
    row "Company" do |c|
      Company.where("id = ?",c.company_id).map(&:name).join(",")
    end
    row :starts
    row :expires

    end
  end

  form :partial => "form"

end
