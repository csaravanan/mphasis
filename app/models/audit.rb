class Audit < ActiveRecord::Base

  # associations
  belongs_to :location
  belongs_to :department
  belongs_to :team
  belongs_to :client
  belongs_to :audit_status
  belongs_to :audit_type
  belongs_to :compliance, foreign_key: 'standard_id'
  belongs_to :company
  has_many :nc_questions, :dependent => :destroy
  has_many :answers, through: :nc_questions
  has_many :default_compliance_libraries, -> { where(is_leaf: true) }, through: :compliance, source: :compliance_library
  has_many :nc_checklist_recommendations, through: :answers , source: :checklist_recommendation
  has_many :compliance_checklist_recommendations, through: :audit_compliances, source: :checklist_recommendation
  has_many :audit_compliances, :dependent => :destroy
  has_many :audit_auditees, :dependent => :destroy
  has_many :artifact_answers, through: :audit_compliances
  has_many :auditees, through: :audit_auditees, :source => :user
  belongs_to :auditory, class_name: 'User', foreign_key: 'auditor'
  has_one :skipped_audit_reminder
  has_many :team_users, through: :team, :source => :users
  has_many :audit_operational_weightages
  has_many :compliance_libraries, through: :audit_compliances


  accepts_nested_attributes_for :nc_questions, :allow_destroy => true
  accepts_nested_attributes_for :audit_auditees, reject_if: lambda { |a| a[:user_id].blank? },:allow_destroy => true
  accepts_nested_attributes_for :nc_questions, :allow_destroy => true

  COMPLIANCE_TYPES = [["Compliance Audit", "Compliance"], ["NonCompliance Audit", "NonCompliance"]]

  # validations
  validates :title, presence:true, length: { in: 0..50 }
  validates :title, uniqueness:true, :if => Proc.new{ |f| !f.title.blank? }
  validates_format_of :title, :with =>/\A(?=.*[a-z])[a-z\d\s]+\Z/i, :if => Proc.new{ |f| !f.title.blank? }
  validates :title, length: { maximum: 250 }, :if => Proc.new{|f| !f.title.blank? }
  validates :auditor, presence:true
  validates :audit_type_id, presence:true
  validates :compliance_type, presence:true
  validates :standard_id, presence:true, :if => Proc.new{ |f| !f.compliance_type.blank? }
  validates :issue, length: { in: 0..250 }, :if => Proc.new{ |f| !f.issue.blank? }
  validates :scope, length: { in: 0..250 }, :if => Proc.new{ |f| !f.scope.blank? }
  validates :context, length: { in: 0..250 }, :if => Proc.new{ |f| !f.context.blank? }
  validates :methodology, length: { in: 0..250 }, :if => Proc.new{ |f| !f.methodology.blank? }
  validates :deliverables, length: { in: 0..250 }, :if => Proc.new{ |f| !f.deliverables.blank? }
  validates :objective, length: { in: 0..250 }, :if => Proc.new{ |f| !f.objective.blank? }
  validates :close_reason, length: { in: 0..250 }, :if => Proc.new{ |f| !f.close_reason.blank? }
  validates :observation, length: { in: 0..250 }, :if => Proc.new{ |f| !f.observation.blank? }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :check_auditees_uniq
  validate :check_auditees_presence
  validate :validate_end_date_before_start_date
  validate :check_for_auditor_in_auditees

  delegate :name, :to => :client, prefix: true, allow_nil: true
  delegate :name, :to => :team, prefix: true, allow_nil: true
  delegate :name, :to => :audit_type, prefix: true, allow_nil: true
  delegate :full_name, :to => :auditory, prefix: true, allow_nil: true
  delegate :email, :to => :auditory, prefix: true, allow_nil: true
  delegate :user_name, :to => :auditory, prefix: true, allow_nil: true
  delegate :name, :to => :location, prefix: true, allow_nil: true
  delegate :name, :to => :department, prefix: true, allow_nil: true
  delegate :name, :to => :audit_status, prefix: true, allow_nil: true

  #scope :with_status, ->(status_id) { where(audit_status_id: status_id)}

  def to_param
    "#{self.id}-#{self.title}"
  end
  def answered_compliances
    self.audit_compliances.where(is_answered: true)
  end

  def answered_answers
    self.answers.where("nc_questions.is_answered = true")
  end

  def auditee_response_compliances(user_id)
    self.audit_compliances.joins(:checklist_recommendation).joins("left OUTER join artifact_answers on audit_compliances.id=artifact_answers.audit_compliance_id").where("is_answered = true and  checklist_recommendations.recommendation_completed = true and artifact_answers.responsibility_id=?",user_id).uniq
  end

  def auditee_response_answers(user_id)
    self.answers.joins(:checklist_recommendation).where("nc_questions.is_answered = true and  checklist_recommendations.recommendation_completed = true and nc_questions.auditee_id=?",user_id).uniq
  end

  def audit_observation_compliances
    self.audit_compliances.joins(:checklist_recommendation).where("is_answered = true and  checklist_recommendations.response_completed = true")
  end

  def audit_observation_answer
    self.answers.joins(:checklist_recommendation).where("nc_questions.is_answered = true and  checklist_recommendations.response_completed = true")
  end

  # Getting all the unanswered Audit compliance for sending reminders
  def unanswered_artifacts
    self.artifact_answers.where("audit_compliances.is_answered=false")
  end

  # Getting all the checklist recommendations for sending reminders
  def unresponsive_recommendation
    self.checklist_recommendations.collect { |x| x if (x.recommendation_completed== true && x.response_completed == false)}
  end

  # Getting all the non compliance for sending reminders
  def unanswered_nc_questions
    self.nc_questions.where("target_date <= ?" , DateTime.now).select{ |x| x.answers.blank?}
  end

  def update_skipped_audit_reminder(params, user)
    self.skipped_audit_reminder.present? ? self.skipped_audit_reminder.update(skipped_by: user.id) : self.build_skipped_audit_reminder(skipped_by: user.id).save if params[:skip_reminder] == "true"
    self.skipped_audit_reminder.destroy if(params[:skip_reminder] == "false" && self.skipped_audit_reminder.present?)
  end

  # def answered_ncquestions
  #   self.nc_questions
  # end

  def audit_compliances_for_current_user(user_id)
    self.audit_compliances.joins("left OUTER join artifact_answers on audit_compliances.id=artifact_answers.audit_compliance_id").where("artifact_answers.responsibility_id=?",user_id).uniq
  end


  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Roo::CSV.new(file.path)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  # Audit create from csv
  def self.import_from_file(file, company)
    spreadsheet = Audit.open_spreadsheet(file)
    start = 2
    (start..spreadsheet.last_row).each do |i|
      row_data = spreadsheet.row(i)
      audit_type = AuditType.where("lower(name) = ?", "#{row_data[7].to_s.strip.downcase}").first
      compliance = row_data[8].strip.downcase=="compliance" ? (comp_type = "Compliance", stand_id = Compliance.where("lower(name) = ?", row_data[9].to_s.strip.downcase).first)  : (comp_type = "NonCompliance", stand_id = Topic.where("lower(name) = ?", row_data[10].to_s.strip.downcase).first)
      audit_initializers(row_data[11].to_s.strip.downcase, row_data[12].to_s.strip.downcase, row_data[13].to_s.strip.downcase, company)
      auditor_user = User.for_users_by_company(row_data[16].to_s.strip.downcase, company.id).last

      audit = Audit.new(:title => row_data[0], :scope => row_data[1], :objective => row_data[2], :issue => row_data[3], :methodology => row_data[4], :deliverables => row_data[5], :context => row_data[6], :audit_type_id => audit_type.present? ? audit_type.id : nil, :compliance_type => compliance[0], :standard_id =>  compliance[1].present? ? compliance[1].id : nil, :location_id =>  @location.present? ? @location.id : nil, :department_id =>  @department.present? ? @department.id : nil, :team_id =>  @team.present? ? @team.id : nil, :start_date =>  row_data[14], :end_date =>  row_data[15], :auditor => auditor_user.present? ? auditor_user.id : nil, :company_id => company.id, :audit_status_id => AuditStatus.where(:name=>"Initiated").first.id)
      audit.save(:validate => false)

      auditee_users = row_data[17].split(', ').collect{|x| User.for_users_by_company(x.strip, company.id)}
      auditee_users.collect{|x| audit.audit_auditees.create(:user_id =>x[0].id) if(@team.present? && @team.users.present? && @team.users.map(&:id).include?(x[0].id))}
    end
  end

  # ASC Score measurement
  def audit_operational_weightage(company)
    over_all_maximum_score = 0
    over_all_total_score = 0
    grouped_audit_compliance = AuditCompliance.joins("join compliance_libraries ON compliance_libraries.id=audit_compliances.compliance_library_id").where("audit_id=?", self.id).group_by {|x| x.compliance_library.parent.parent_id}

    grouped_audit_compliance.each do |k, v|
      operational_area = OperationalArea.find_or_initialize_by(compliance_library_id: k, company_id: company.id)
      if(operational_area.new_record?)
        operational_area.weightage = 1
        operational_area.company_id = company.id
        operational_area.save
      end

      #  Sum of scores of each control
      total_score = v.sum{|x| x.score_level.to_i}
      over_all_total_score += total_score

      # Weightage
      weightage = total_score * operational_area.weightage

      # Compliance Percentage Calculation
      # maximum_rating = (v.count * operational_area.weightage).to_f
      maximum_rating = (v.count * 4)
      maximum_score = (maximum_rating * operational_area.weightage).to_f
      over_all_maximum_score += maximum_score
      compliance_percentage = (weightage / maximum_score ) * 100
      rating = get_compliance_rating(compliance_percentage)

      # AuditOperationalWeightage
      AuditOperationalWeightage.create(operational_area_id: operational_area.id, audit_id: self.id, weightage: weightage, total_score: total_score, percentage: compliance_percentage, rating: rating, maximum_score: maximum_score)
    end
    # total compliance percentage
    total_maximum_score = over_all_maximum_score.to_f
    total_weightage = over_all_total_score.to_f
    total_compliance_percentage = (total_weightage/total_maximum_score) * 100

    self.update(percentage: total_compliance_percentage)
  end

  def checklist_recommendations
    (self.compliance_checklist_recommendations + self.nc_checklist_recommendations).uniq
  end

  # Method to get Compliance Percentage
  def get_compliance_rating(compliance_percentage)
    case compliance_percentage
      when compliance_percentage <= 50
        return 1
      when compliance_percentage <= 70
        return 2
      when compliance_percentage <= 90
        return 3
      when compliance_percentage <=100
        return 4
      else
        return 1
    end
  end

  def maximum_actual_score
    audit_domains = self.audit_operational_weightages.collect{|x| x.operational_area.compliance_library_name}
    audit_weightage = self.audit_operational_weightages.map(&:weightage)
    audit_percentage = self.audit_operational_weightages.map(&:percentage)
    audit_maximum_score = self.audit_operational_weightages.map(&:maximum_score)
    return audit_domains, audit_weightage, audit_maximum_score, audit_percentage
  end

  def audit_users
    audit_users = self.auditees.map(&:full_name)
    audit_users << self.auditory_full_name
    audit_users.compact
  end

  def audit_status_records
    recommendation_completed_status = []
    response_completed_status = []
    observation_completed_status = []
    recommendation_pending_status = []
    response_pending_status = []
    observation_pending_status = []
    checklist_completed_status = []
    checklist_pending_status = []
    self.checklist_recommendations.each do |checklist|
      checklist.recommendation_completed.nil? ? checklist_pending_status << checklist.recommendation_completed  : checklist_completed_status << checklist.recommendation_completed
      checklist.response_completed.nil? ? checklist_pending_status << checklist.response_completed : checklist_completed_status << checklist.response_completed
      checklist.is_published.nil? ? checklist_pending_status << checklist.is_published  : checklist_completed_status << checklist.is_published
      recommendation_completed_status = self.checklist_recommendations.map(&:recommendation_completed).compact.count
      recommendation_pending_status = self.checklist_recommendations.count - recommendation_completed_status
      response_completed_status = self.checklist_recommendations.map(&:response_completed).compact.count
      response_pending_status = self.checklist_recommendations.count - response_completed_status
      observation_completed_status = self.checklist_recommendations.map(&:is_published).compact.count
      observation_pending_status = self.checklist_recommendations.count - observation_completed_status
    end
    return checklist_completed_status.count, checklist_pending_status.count, recommendation_completed_status, recommendation_pending_status, observation_completed_status, observation_pending_status, response_completed_status, response_pending_status
  end

  def recommendation_status
    self.checklist_recommendations.present? ? self.checklist_recommendations.map(&:recommendation_completed).all?{ |x| x == true } : false
  end

  def response_status
    self.checklist_recommendations.present? ? self.checklist_recommendations.map(&:response_completed).all?{ |x| x == true } : false
  end

  def observation_status
    self.checklist_recommendations.present? ? self.checklist_recommendations.map(&:is_published).all?{ |x| x == true } : false
  end

  def build_audit_compliance(compliance_params)
      old_compliance = self.audit_compliances.map(&:id)
      compliance_params.each do |k, v|
        audit_compliance = AuditCompliance.find_or_create_by(compliance_library_id: v["compliance_library_id"], audit_id: self.id)
        old_compliance.delete(audit_compliance.id)
        old_artifact_answers = audit_compliance.artifact_answers.map(&:id)
        if(v["artifact_id"].present?)
            artifact_ids =  v["artifact_id"].class == Array ? v["artifact_id"] : v["artifact_id"].split(",")
            artifact_ids.each do |artifact_id|
              artifact_answer = ArtifactAnswer.find_or_initialize_by(artifact_id: artifact_id.to_i, audit_compliance_id: audit_compliance.id)
              old_artifact_answers.delete(artifact_answer.id)
              artifact_answer.update(v.reject{|x| x=="artifact_id" || x=="compliance_library_id" || x=="artifact_answers"})
            end
        else
            if(v["artifact_answers"].present?)
              artifact_answer = ArtifactAnswer.find(v["artifact_answers"].to_i) rescue ""
              if(artifact_answer.present? && !artifact_answer.artifact_id.present?)
                old_artifact_answers.delete(artifact_answer.id)
                artifact_answer.update(v.reject{|x| x=="artifact_id" || x=="compliance_library_id" || x == "artifact_answers"})
              end
            else
              artifact_answer = audit_compliance.artifact_answers.create(v.reject{|x| x=="artifact_id" || x=="compliance_library_id" || x == "artifact_answers"})
            end
        end
        ArtifactAnswer.delete(old_artifact_answers) if old_artifact_answers.present?
      end
      AuditCompliance.delete(old_compliance) if old_compliance.present?
  end

  def set_audit_status(audit, commit_name)
    audit.audit_status_id = ((commit_name == "Save as Plan") ?  AuditStatus.for_name("Planning").id : AuditStatus.for_name("In Progress").id)
    return audit
  end


  protected
    def self.audit_initializers(location_name, department_name, team_name, company)
      @location = Location.for_name_by_company(location_name, company.id).first
      @department = Department.for_name_by_location(department_name, @location.id).first if @location.present?
      section = Section.by_name('Audit').first
      @team = Team.for_name_by_department(team_name, @department.id, section.id).first if @department.present?
    end

  private
    def check_auditees_uniq
      if self.audit_auditees.present?
        check_user_id = audit_auditees.size == audit_auditees.collect{|x| x.user_id}.uniq.size
        errors.add(:auditees, ("Please select unique auditees")) if check_user_id == false
      end
    end

    def check_auditees_presence
      self.errors[:auditees] = MESSAGES['audit']['failure']['auditee_blank'] unless audit_auditees.present?
    end

    def validate_end_date_before_start_date
      if end_date && start_date
        self.errors[:end_date] = MESSAGES['audit']['failure']['start_date_before_end_date'] if end_date < start_date
      end
    end

    def check_for_auditor_in_auditees
      self.errors[:auditees] = MESSAGES['audit']['failure']['auditor_not_in_auditees'] if audit_auditees.map(&:user_id).include?(self.auditor)
    end

end
