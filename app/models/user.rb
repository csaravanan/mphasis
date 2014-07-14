class User < ActiveRecord::Base


  # Include default devise modules. Others available are:
  #  :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable, :lockable, :authentication_keys => [:login, :domain]

  belongs_to :role
  has_many :privileges, through: :role

  has_many :teams, through: :user_teams
  has_many :user_teams

  belongs_to :company
  belongs_to :language

  has_one :attachment, as: :attachable
  has_one :profile
  has_many :nc_questions

  has_many :checklist_recommendations

  has_many :audit_auditees

  has_many :auditee_audit, through: :audit_auditees, source: :audit

  has_many :auditor_audits, class_name: 'Audit', foreign_key: 'auditor'

  has_many :artifact_answers

  belongs_to :user_manager, class_name: 'User', foreign_key: 'manager'

  # Associations with Risk Tables
  has_many :risk_owner, class_name: 'Risk', foreign_key: 'owner'
  has_many :risk_mitigator, class_name: 'Risk', foreign_key: 'mitigator'
  has_many :risk_reviewer, class_name: 'Risk', foreign_key: 'reviewer'
  has_many :risk_submitor, class_name: 'Risk', foreign_key: 'submitted_by'
  has_many :mitigation_submitor, class_name: 'Mitigation', foreign_key: 'submitted_by'
  has_many :mgmt_reviews
  has_many :closures


# attribute to login with username or email
  attr_accessor :login, :domain

   validates_format_of :full_name, :with =>/\A[a-zA-Z ]+\z/, :if => Proc.new{|f| !f.full_name.blank? }
   validates :full_name, length: { maximum: 50 }, :if => Proc.new{|f| !f.full_name.blank? }
   validates :user_name, presence: true, :if => Proc.new{|f| f.user_name.blank? }
   validates :user_name, uniqueness: true, :if => Proc.new{|f| !f.user_name.blank? }
   validates :user_name, length: { maximum: 52 }, :if => Proc.new{|f| !f.user_name.blank? }
   validates :email, presence: true
   validates :email, uniqueness: true, :if => Proc.new{|f| !f.email.blank? }
   validates :email, length: {  maximum: 50  },:if => Proc.new{|f| !f.email.blank? }
   validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create, :if => Proc.new{|f| !f.email.blank? }
   validates :role_id, presence: true
   validates :password, presence: true, :if => Proc.new{ |f| (f.reset_password_token.present?) }
   validates :password, confirmation: true
   validates :password, length: {in: 6..20}, :unless => lambda{ |a| a.password.blank? }
  validate :user_name_without_spaces
  validate :company_user_count, :if => Proc.new{|f| f.role_title != 'company_admin' && f.id.nil? }



  delegate :title, to: :dealer, prefix: true
  delegate :title, to: :role, prefix: true, allow_nil: true
  delegate :email, to: :user_manager, prefix: true, allow_nil: true
  delegate :attachment_file, to: :attachment, prefix: true, allow_nil: true

  #scope
  scope :for_users_by_company, lambda {|email, company_id| where(email: email, company_id: company_id)}
  # scope :for_id, lambda {|team_id| where(id: team_id)}

  def is?( requested_role)
    self.role.title == requested_role.to_s if self.role.present?
  end

  def user_previleges
    @grouped_modular_action ||= self.role.privileges.map(&:modular).group_by(&:action_name) if self.role.present?
  end

  def display_name
    self.full_name || self.user_name
  end


# Restricting user to login if the account is disable
  def active_for_authentication?
    super && !self.is_disabled
  end

  def accessible_audits
    if(self.role.title == "company_admin")
      Audit.where(company_id: self.company_id)
    else
      (self.auditor_audits + self.auditee_audit).uniq
    end
  end

  def accessible_risks
    if(self.role.title == "company_admin")
      Risk.where(company_id: self.company_id)
    else
      (self.risk_owner + self.risk_submitor + self.risk_mitigator + self.risk_reviewer).uniq
    end
  end

  def audits_stage(params)
    audits = []
    case params[:stage]
    when 'do'
      self.accessible_audits.select{ |x| audits << x if(x.checklist_recommendations.blank? && ( x.audit_status_id == 2 || x.audit_status_id == 3 )) }
      audits
    when 'check'
      self.accessible_audits.select{ |x| audits << x if(x.checklist_recommendations.present? && !x.recommendation_status) }
      audits
    when 'act'
      self.accessible_audits.select{ |x| audits << x if(x.recommendation_status && !x.response_status) }
      audits
    when 'published'
      self.accessible_audits.select{ |x| audits << x if(x.response_status && !x.observation_status) }
      audits
    end
  end

  def risks_stage(params)
    risks = []
    case params[:stage]
    when 'mitigate'
      self.accessible_risks.select{ |x| risks << x if(x.mitigation.blank? && ( x.risk_status_name == "Initiated")) }
      risks
    when 'review'
      self.accessible_risks.select{ |x| risks << x if(x.mitigation.present? ) }
      risks
    end
  end

  protected

  def password_required?
    super if confirmed?
  end

  # Nested attribute for Profile
  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :attachment, reject_if: lambda { |a| a[:attachment_file].blank? }, allow_destroy: true


  # to have a login with username or email , we have to overwrite the method find_first_by_auth_conditions in devise

    def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if((domain = conditions.delete(:domain)) && (login = conditions.delete(:login)))
        if(domain && (company = Company.where(domain: domain).first))
          where(conditions).where(["(lower(user_name) = :value OR lower(email) = :value) AND company_id = :company_id", { :value => login.downcase, :company_id => company.id }]).first
        else
          where(conditions).where(["lower(user_name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
        end
      else
        where(conditions).first
      end
    end

  private
    def user_name_without_spaces
      username_match = self.user_name.match(/[\s+\d+]/) ? true : false
      errors.add(:user_name) if username_match == true
    end

    def company_user_count
      company = self.company
      self.errors[:user_count_exceeds] = ",you can't create new user"  if company.users.count >= company.plan.subscription_user_count
    end
end
