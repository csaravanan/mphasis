class MyNavigation < ActiveAdmin::Component
		def build(namespace, menu)

			if current_admin_user
				render :partial => "/layouts/admin_header"
			else
			render :partial => "/layouts/company_admin_header"
			end
		end
			
end