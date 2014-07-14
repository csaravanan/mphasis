class Risk < ActiveRecord::Base

  #publicactivity gem
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked ip: ->(controller,model) {controller && controller.current_user.current_sign_in_ip}


	# Associations
	has_one :mgmt_review
	has_many :closures
	has_one :control_measure
	has_one :risk_scoring
	has_one :mitigation
  has_one :attachment, as: :attachable
	belongs_to :risk_status
	belongs_to :compliance
	belongs_to :location
	belongs_to :company
	belongs_to :risk_owner, class_name: 'User', foreign_key: 'owner'
	belongs_to :risk_mitigator, class_name: 'User', foreign_key: 'mitigator'
	belongs_to :risk_reviewer, class_name: 'User', foreign_key: 'reviewer'
	belongs_to :risk_category, class_name: 'RiskCategory', foreign_key: 'category_id'
	belongs_to :team
	belongs_to :department
	belongs_to :compliance_library
	belongs_to :technology
	belongs_to :risk_model
	belongs_to :submitor, class_name: 'User', foreign_key: 'submitted_by'
	belongs_to :project
	belongs_to :risk_approval_status, foreign_key: 'risk_approval_status_id'

  # Validations
  validates :subject, presence:true, length: { in: 0..250 }, :if => Proc.new{ |f| !f.subject.blank? }
  # validates :compliance_library_id, presence:true
  validates :assessment, presence:true
  validates :notes, length: { in: 0..250 }
  validates :reference, presence:true, length: { in: 0..250 }
  validates :reference, uniqueness:true, :if => Proc.new{ |f| !f.reference.blank? }
  validates :reference, :uniqueness => {:scope => :company_id}, :if => Proc.new{ |f| !f.reference.blank? }
  validates :compliance_id, presence:true
  validates :category_id, presence:true
  validates :technology_id, presence:true
  validates :owner, presence:true
  validates :mitigator, presence:true
  validates :reviewer, presence:true
  validates :submitted_by, presence:true
  # validate :check_for_owner_and_mitigator
  validate :check_scoring_type

	delegate :name, to: :risk_status, prefix: true, allow_nil: true
	delegate :user_name, to: :risk_owner, prefix: true, allow_nil: true
	delegate :scoring_type, to: :risk_scoring, prefix: true, allow_nil: true
	delegate :calculated_risk, to: :risk_scoring, prefix: true, allow_nil: true
	delegate :custom_value, to: :risk_scoring, prefix: true, allow_nil: true
	delegate :name, to: :location, prefix: true, allow_nil: true
	delegate :name, to: :team, prefix: true, allow_nil: true
	delegate :name, to: :compliance, prefix: true, allow_nil: true
	delegate :name, to: :risk_category, prefix: true, allow_nil: true
	delegate :name, to: :technology, prefix: true, allow_nil: true
	delegate :name, to: :risk_model, prefix: true, allow_nil:true


	accepts_nested_attributes_for :mitigation
  accepts_nested_attributes_for :control_measure
  accepts_nested_attributes_for :risk_scoring
  accepts_nested_attributes_for :attachment, reject_if: lambda { |a| a[:attachment_file].blank? }

  # callbacks
  after_create :notify_risk_users

	def self.risk_rating(company_id)
		high_risk = RiskReviewLevel.review_level('HIGH',company_id).first
		medium_risk = RiskReviewLevel.review_level('MEDIUM',company_id).first
		low_risk = RiskReviewLevel.review_level('LOW',company_id).first
		return high_risk, medium_risk, low_risk
	end

	def notify_risk_users
		users_email = []
		subject_array = ["Your risk has been successfully created and assigned", "A new risk has been assigned to you for mitigation"]
		users_email << self.risk_owner.email << self.risk_mitigator.email
    users_email.each_with_index do |email, index|
    	RiskMailer.delay.notify_users_about_risk(self, email, subject_array[index], name="risk")
    end
  end

  def self.import_from_file(file, company, user)
    spreadsheet = Risk.open_spreadsheet(file)
    start = 2
    (start..spreadsheet.last_row).each do |i|
      row_data = spreadsheet.row(i)
      risk_initializers(row_data[4].to_s.strip.downcase, row_data[5].to_s.strip.downcase, row_data[6].to_s.strip.downcase, company)

      category = RiskCategory.for_name(row_data[7].to_s.strip.downcase).last
      technology = Technology.for_name(row_data[8].to_s.strip.downcase).last

      owner = User.for_users_by_company(row_data[9].to_s.strip.downcase, company.id).last
      mitigator = User.for_users_by_company(row_data[10].to_s.strip.downcase, company.id).last
      reviewer = User.for_users_by_company(row_data[11].to_s.strip.downcase, company.id).last

      risk = Risk.new(:subject => row_data[0], :reference => row_data[1], :location_id =>  @location.present? ? @location.id : nil, :department_id =>  @department.present? ? @department.id : nil, :team_id =>  @team.present? ? @team.id : nil, :category_id => (category.present? && (category.company_id == company.id || category.company_id.nil?)) ? category.id : nil, :technology_id =>  (technology.present? && (technology.company_id == company.id || technology.company_id.nil?)) ? technology.id : nil, :owner => owner.present? ? owner.id : nil, :mitigator => mitigator.present? ? mitigator.id : nil, :reviewer => reviewer.present? ? reviewer.id : nil, :assessment => row_data[12], :notes => row_data[13], :company_id => company.id, :submitted_by => user.id, :risk_status_id => RiskStatus.where(:name=>"Draft").first.id)
      risk.save(:validate => false)
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Roo::CSV.new(file.path)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def set_risk_status(risk, commit_name)
    risk.risk_status_id = ((commit_name == "Save as Draft") ?  RiskStatus.for_name("Draft").first.id : RiskStatus.for_name("Initiated").first.id)
    return risk
  end

  def update_risk_scoring(risk)
    scoring_type = risk.risk_scoring.scoring_type
    risk.risk_scoring.dread_scoring_method if scoring_type == "DreadScoring"
    risk.risk_scoring.owasp_scoring_method if scoring_type == "OwaspScoring"
    risk.risk_scoring.classic_scoring_method(risk.risk_model_name) if scoring_type == "ClassicScoring"
    risk.risk_scoring.cvss_scoring_method if scoring_type == "CvssScoring"
  end

  protected
    def self.risk_initializers(location_name, department_name, team_name, company)
      @location = Location.for_name_by_company(location_name, company.id).first
      @department = Department.for_name_by_location(department_name, @location.id).first if @location.present?
      section = Section.by_name('Risk').first
      @team = Team.for_name_by_department(team_name, @department.id, section.id).first if @department.present?
    end

  private
    def check_for_owner_and_mitigator
      self.errors[:mitigator] = MESSAGES['risk']['failure']['owner_not_in_mitigator'] if self.owner == self.mitigator
    end

    def check_scoring_type
      errors.add(:scoring_type, ("Please select scoring type")) if self.risk_scoring.scoring_type.blank?
    end
end