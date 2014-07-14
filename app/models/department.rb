class Department < ActiveRecord::Base
  #publicactivity gem
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked ip: ->(controller,model) {controller && controller.current_user.current_sign_in_ip}

  # associations
  has_many :audits
  has_many :teams, :dependent => :destroy
  belongs_to :location
  has_many :risks
  belongs_to :company

  # validations
  validates :name, presence:true
  validates_format_of :name, :with =>/\A(?=.*[a-z])[a-z\d\s]+\Z/i,:if => Proc.new{|f| !f.name.blank? }
  validates :name, length: { maximum: 50 }, :if => Proc.new{|f| !f.name.blank? }
  validates_uniqueness_of :name, scope: [:location_id]
  validates :location_id, presence:true

  #scope
  scope :for_location, lambda {|location_id| where(location_id: location_id)}
  scope :for_name_by_location, lambda  {|department_name, location_id| where("lower(name) = ? and location_id=?", department_name, location_id)}

end
