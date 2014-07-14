class ArtifactAnswer < ActiveRecord::Base

# Relationship
 belongs_to :audit_compliance
 belongs_to :artifact
 belongs_to :responsibility , :class_name => "User", foreign_key: 'responsibility_id'
 belongs_to :priority , :class_name => "Priority"
 has_one :comment , as: :commentable
 has_many :attachments, as: :attachable

 accepts_nested_attributes_for :comment, reject_if: lambda { |a| a[:comment].blank? }, allow_destroy: true

  delegate :name, to: :priority, prefix: true, allow_nil: true
  delegate :full_name, to: :responsibility, prefix: true, allow_nil: true
  delegate :email, to: :responsibility, prefix: true, allow_nil: true
  delegate :name, to: :artifact, prefix: true, allow_nil: true
  delegate :comment, to: :comment, prefix: true, allow_nil: true

  validates :responsibility_id, presence: true
  validates :target_date, presence: true

  def artifact_display_name
  	self.artifact_id ? self.artifact_name : "No Attachments"
  end

  after_create :notify_auditee_about_checklist
  after_update :notify_auditee_about_checklist_update

  def notify_auditee_about_checklist
    ReminderMailer.delay.notify_auditee_about_checklist(self)
  end

  def notify_auditee_about_checklist_update
    ReminderMailer.delay.notify_auditee_about_checklist_update(self)
  end

  def build_checklist(compliance)
    json = {}
    json["id"] = self.id
    json["name"] = compliance.compliance_library_name
    json["artifact_id"] = self.artifact_id
    json["artifact_name"] = self.artifact_name
    json["audit_compliance"] = compliance.id
    json["priority"] = self.priority_name
    json["auditee"] = self.responsibility_full_name
    json["target_date"] = (self.target_date.present? ? self.target_date.to_date.strftime("%d/%m/%Y") : "")
    json
  end

end
