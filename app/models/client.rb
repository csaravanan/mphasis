
class Client < ActiveRecord::Base
  #publicactivity gem
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked ip: ->(controller,model) {controller && controller.current_user.current_sign_in_ip}

  # associations
  has_many :audits
  belongs_to :company #client belongs to a company


  # validations
  validates :name, presence:true
  validates_format_of :name, :with =>/\A(?=.*[a-z])[a-z\d\s]+\Z/i, :if => Proc.new{ |f| !f.name.blank? }
  validates :name, uniqueness:true, :if => Proc.new{ |f| !f.name.blank? }
  validates :name, length: { in: 2..52 }, :if => Proc.new{ |f| !f.name.blank? }
  validates :address1, length: { in: 7..40 },:if => Proc.new{|f| !f.address1.blank? }
  validates :address2, length: { in: 7..40 },:if => Proc.new{|f| !f.address2.blank? }
  validates :email, presence: true
  validates :email, uniqueness: true,:if => Proc.new{|f| !f.email.blank? }
  validates :email, length: { maximum: 50 },:if => Proc.new{|f| !f.email.blank? }
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,:if => Proc.new{|f| !f.email.blank? }
  validates :contact_no, presence:true, length: { in: 10..15 }
  validates_numericality_of :contact_no, :if => Proc.new{|f| !f.contact_no.blank? }
  validates :contact_no, length: { :maximum => 15}, :if => Proc.new{|f| !f.contact_no.blank? }
end
