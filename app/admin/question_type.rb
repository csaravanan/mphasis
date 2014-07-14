ActiveAdmin.register QuestionType do

  menu :if => proc{ current_admin_user.present? }
 #authentication
 controller do
  before_filter :authenticate_admin_user!
  before_filter :check_subdomain
 end
 permit_params :name

   index do
    selectable_column
   	column :name
   	actions
   end

   show do
 	 attributes_table :name
   end

   form do |f|
    f.inputs "Add Question type" do
      f.input :name
    end
    f.actions
   end
end