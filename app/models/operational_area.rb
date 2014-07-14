class OperationalArea < ActiveRecord::Base
  #publicactivity gem
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked ip: ->(controller,model) {controller && controller.current_user.current_sign_in_ip}

  # Association
  has_many :audit_operational_weightages
  belongs_to :compliance_library
  belongs_to :company

  delegate :name, to: :compliance_library, prefix: true, allow_nil: true

  # validation
  validates :compliance_library_id ,:uniqueness => {:scope => :company_id}
  validates :weightage, :numericality => { :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5, :only_integer => true}
end
