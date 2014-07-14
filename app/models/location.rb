class Location < ActiveRecord::Base
 #publicactivity gem
	 include PublicActivity::Model
   tracked owner: ->(controller, model) { controller && controller.current_user }
   tracked ip: ->(controller,model) {controller && controller.current_user.current_sign_in_ip}

  # Validation
  validates :name, presence:true
  validates_format_of :name, :with =>/\A(?=.*[a-z])[a-z\d\s]+\Z/i, :if => Proc.new{ |f| !f.name.blank? }
  validates :name, length: { in: 4..52 }, :if => Proc.new{ |f| !f.name.blank? }
  validates_uniqueness_of :name, scope: [:company_id]

  scope :for_name_by_company, lambda {|location_name, company_id| where("lower(name)=? and company_id=?", location_name, company_id)}

  has_many :departments, :dependent => :destroy
  belongs_to :company
  has_many :audits
  has_many :risks
end
