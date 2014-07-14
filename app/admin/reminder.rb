ActiveAdmin.register Reminder do

  menu :if => proc{ !current_admin_user.present? }

  breadcrumb do
    [
      link_to('Reminder', '/admin/reminders')
    ]
  end

  actions :all, :except => [:destroy]

  controller do
    before_filter :check_company_admin, :check_role, :check_subdomain, :company_admin_module_check


    def scoped_collection
        current_company.reminders
    end

    def create
      @reminder = Reminder.new(reminder_params)
      @reminder.company_id = current_user.company_id
      if @reminder.save
        redirect_to admin_reminders_path
      else
        @errors = @reminder.errors
        # redirect_to new_admin_remainder_path
        render 'new'
     end
    end

    private
      def reminder_params
        params.require(:reminder).permit(:priority_id, :value, :time_line ,:company_id , :to, :cc, :mail_count)
      end

      def scoped_collection
        current_company.reminders
      end
  end

  index do
    column "Priority" do |p|
      p.priority.name
    end
    column :value
    column :time_line do |t|
        t.time_line == 1 ? 'Hours': 'Days'
    end
    column :mail_count
    column :mail_to
    column :mail_cc
    actions
  end

  show do
    attributes_table do
      row "Priority" do |p|
        p.priority.name
      end
      row :value
      row :time_line do |t|
        t.time_line == 1 ? 'Hours': 'Days'
      end
      row :mail_count
    end
  end

  form do |f|
    f.inputs "Set Reminders" do
      f.input :priority , :prompt => "-Select priority-"
      f.input :value
      f.input :time_line , as: :select, collection: [['Hours', '1'], ['Days', '2']] , :prompt => "-Select Timeline-"
      f.input :mail_count
      f.input :to , as: :select, collection: ReminderAssignment.all , :prompt => "-Select-"
      f.input :cc, as: :select, collection: ReminderAssignment.all, :prompt => "-Select-"
    end
    f.actions
  end

  def convert_to_string(timeline)
    if timeline == 1
      return "Hours"
    else
      return "Days"
    end
  end

  permit_params :priority_id, :value, :time_line, :last_sent, :company_id, :to,:cc, :mail_count

end