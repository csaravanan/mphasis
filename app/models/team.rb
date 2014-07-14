class Team < ActiveRecord::Base
  #publicactivity gem
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked ip: ->(controller,model) {controller && controller.current_user.current_sign_in_ip}

  #associations
  has_many :users, :through => :user_teams
  has_many :user_teams, :dependent => :destroy
  has_many :audits
  belongs_to :company
  belongs_to :department
  belongs_to :section
  has_many :risks


  # validations
  validates :name, presence:true
  validates_format_of :name, :with =>/\A(?=.*[a-z])[a-z\d\s -]+\Z/i, :if => Proc.new{ |f| !f.name.blank? }
  validates :name, :uniqueness => {:scope => :company_id}, :if => Proc.new{ |f| !f.name.blank? }

  #scope
  scope :for_department_and_company, lambda {|department_id, company_id, section_id| where(department_id: department_id, company_id: company_id, section_id: section_id)}
  scope :for_id, lambda {|team_id| where(id: team_id)}
  scope :for_name_by_department, lambda { |team_name, department_id, section| where("lower(name) = ? and department_id = ? and section_id = ?", team_name, department_id, section) }
end
