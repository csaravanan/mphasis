class Role < ActiveRecord::Base

   #publicactivity gem
    include PublicActivity::Model
   #~ include PublicActivity::Common
     #~ tracked owner: ->(controller, model) { controller && controller.current_user }, :if => Proc.new{ current_user }
     #~ tracked ip: ->(controller,model) {controller && controller.current_user.current_sign_in_ip}

 #validation
    validates :title, presence:true,:if => Proc.new{|f| f.title.blank? }
    validates :title, length: { in: 2..25 }
    validates_format_of :title, :with =>/\A[a-zA-Z ]+\z/, :if => Proc.new{ |f| !f.title.blank? }
    validates :title, exclusion: { in: %w(company_admin) ,:if => Proc.new{ |f| (f.title.nil?) }}
    validates :title, :uniqueness => {:scope => :company_id}, :if => Proc.new{ |f| !f.title.blank? }
    has_many :privileges
    has_many :roles
    belongs_to :company

  scope :title, ->(role_id) { where(id: role_id).first.title}
  scope :for_title_by_company, lambda {|title, company_id| where("title = ? AND company_id = ?", title, company_id)}

end