class Compliance < ActiveRecord::Base
    #publicactivity gem
   #~ include PublicActivity::Model
   #~ tracked owner: ->(controller, model) { controller && controller.current_user }
   #~ tracked ip: ->(controller,model) {controller && controller.current_user.current_sign_in_ip}

	  validates :name, presence:true, :if => Proc.new{|f| f.name.blank? }
	  validates_format_of :name, :with =>/\A(?=.*[a-z])[a-z\d\s]+\Z/i, :if => Proc.new{ |f| !f.name.blank? }
    validates :name, uniqueness:true, :if => Proc.new{|f| !f.name.blank? }
    validates :name, length: { in: 2..52 }, :if => Proc.new{ |f| !f.name.blank? }

    scope :by_name, lambda {|name| where("lower(name) = ?", name)}

    #Association
    has_many :audits
    has_many :compliance_library
    has_many :risks
    has_many :cpp_measures
end
