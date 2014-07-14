namespace :plan do
  desc "plan notification"
  	task notify: :environment do
  		company = Company.find(65)
    	company.each do |company|
    	 	plan = company.plan
         	user = company.users
         	user_email = user.map(&:email) if user.map(&:role_title).eql?("company_admin")
       		if plan.expires.to_date.eql?(Date.today)
        	  SubscriptionNotifier.plan_expire_notification(user_email, plan)
       		elsif plan.expires.to_date.eql?(plan.expires.to_date - 2.days)  
         	  SubscriptionNotifier.plan_notification(user_email, plan)
        	end

          #change the company plan to free - when plan expires for paid users#
          
    	end
 	end
end
