class ChecklistRecommendation < ActiveRecord::Base
	attr_accessor :is_checklist_new, :last_step
	# belongs_to :auditee_id, :class_name => "ArtifactAnswer"
	belongs_to :rec_priority, :class_name =>"Priority", foreign_key: :recommendation_priority
	belongs_to :rec_severity, :class_name =>"Priority", foreign_key: :recommendation_severity
	belongs_to :response_priority, :class_name =>"Priority"
	belongs_to :response_severity, :class_name =>"Priority"
	belongs_to :recommendation_severity, :class_name =>"Priority"
	belongs_to :recommendation_priority, :class_name =>"Priority"
	belongs_to :recommendation_status, :class_name =>"RecommendationStatus"
	belongs_to :response_status, :class_name => "ResponseStatus"
	belongs_to :response_status
	belongs_to :dependent_checklist, :class_name => "ChecklistRecommendation", foreign_key: "dependent_recommendation"
	belongs_to :blocking_checklist, :class_name => "ChecklistRecommendation", foreign_key: "blocking_recommendation"
	belongs_to :checklist, polymorphic: true
	has_many :attachments , as: :attachable
	belongs_to :auditee, class_name: 'User', foreign_key: 'auditee_id'
	has_one :remark , as: :commentable, class_name: "Comment"

    before_create :check_for_published
    before_save :check_for_published

	#validation
	validates :recommendation, presence: true
	validates :reason, presence: true
	validates :recommendation_priority_id, presence: true
	validates :recommendation_severity_id, presence: true
	validates :closure_date, presence: true
	validates :recommendation_status_id, presence: true
	validates :preventive, presence: true, :if => Proc.new{|f|  f.recommendation_completed == true && f.is_checklist_new != true}
	validates :corrective, presence: true, :if => Proc.new{|f| f.recommendation_completed == true && f.is_checklist_new != true}
	validates :response_status_id, presence: true, :if => Proc.new{|f| f.recommendation_completed == true && f.is_checklist_new != true}
	validates :response_priority_id, presence: true, :if => Proc.new{|f| f.recommendation_completed == true && f.is_checklist_new != true}
	validates :response_severity_id, presence: true, :if => Proc.new{|f| f.recommendation_completed == true && f.is_checklist_new != true}
	validates :observation, presence: true, :if => Proc.new{|f| f.recommendation_completed == true && f.response_completed == true && f.is_checklist_new != true}
	validates :is_implemented, presence: true, :if => Proc.new{|f| f.recommendation_completed == true &&  f.response_completed == true && f.is_checklist_new != true}
	validates :recommendation_status_id, presence: true


	delegate :name, :to => :recommendation_priority, prefix: true, allow_nil: true
	delegate :name, :to => :recommendation_severity, prefix: true, allow_nil: true
	delegate :name, :to => :recommendation_status, prefix: true, allow_nil: true
	delegate :name, :to => :response_status, prefix: true, allow_nil: :true
  	delegate :name, to: :response_priority, prefix: true, allow_nil: :true
  	delegate :name, to: :response_severity, prefix: true, allow_nil: :true
	delegate :comment, to: :remark, prefix: true, allow_nil: :true
  	delegate :email, to: :auditee, prefix: true, allow_nil: :true
  	delegate :recommendation, to: :blocking_checklist, prefix: true, allow_nil: :true
	delegate :recommendation, to: :dependent_checklist, prefix: true, allow_nil: :true



	#~ delegate :audit_id, to: :checklist_recommendation, prefix: true, allow_nil: true
	#~ accepts_nested_attributes_for :attachment, reject_if: lambda { |a| a[:attachment_file].blank? }, allow_destroy: true

	def audit_checklist(checklist_input)
		checklist_params =[]
			checklist_recommendation_id = checklist_input[:checklist_recommendation].collect {|k,v| v}
			checklist_recommendation_id.each do |record|
			checklist_params << record
		end
		return checklist_params
	end

  after_create :notify_auditee_about_recommendation
  after_update :notify_if_recommendation_changed

  def notify_auditee_about_recommendation
    ReminderMailer.delay.notify_auditee_about_recommendations(self, action="created")
  end

  def notify_if_recommendation_changed
    recommendation = (self.recommendation_changed? || self.reason_changed? || self.closure_date_changed? || self.recommendation_priority_id_changed? || self.recommendation_severity_id_changed? || self.recommendation_status_id_changed?)
    ReminderMailer.delay.notify_auditee_about_recommendations(self, action="updated") if recommendation

    response = (self.corrective_changed? || self.response_status_id_changed? || self.preventive_changed? || self.response_priority_id_changed? || self.dependent_recommendation_changed? || self.blocking_recommendation_changed? || self.response_severity_id_changed?)
    checklist_created = self.response_completed_changed? ? "created" : "updated"
    ReminderMailer.delay.notify_auditor_about_responses(self, checklist_created) if response

    publish = (self.observation_changed? || self.is_implemented_changed?)
    published = self.is_published_changed? ? "created" : "updated"
    ReminderMailer.delay.notify_auditee_about_observations(self, published) if publish
  end

  def response_attachments
    self.attachments.where(classified: "Auditee Response")
  end

  def observation_attachments
    self.attachments.where(classified: "Audit Observation")
  end

  def check_for_published
  	if(self.last_step)
  		return true
  	elsif(self.is_published)
  		return false
  	end
  end

end
