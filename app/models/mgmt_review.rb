class MgmtReview < ActiveRecord::Base

  #publicactivity gem
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked ip: ->(controller,model) {controller && controller.current_user.current_sign_in_ip}

	# Associations
	belongs_to :risk
	belongs_to :review
	belongs_to :mgmt_reviewer, class_name: "User", foreign_key: :reviewer
	belongs_to :next_step
	has_one :comment , as: :commentable, class_name: "Comment"
	accepts_nested_attributes_for :comment, :allow_destroy => true


	delegate :name, to: :review, prefix: true, allow_nil: :true
	delegate :name, to: :next_step, prefix: true, allow_nil: :true

	# callbacks
  after_create :notify_risk_users_about_mgmt_reviews

  def notify_risk_users_about_mgmt_reviews
    risk = self.risk
    users_email = []
    subject_array = ["Management review has been done for your risk", "Management review has been done for your risk", "Your Review has been successfully added", "Management review has been done for your risk"]
    users_email << risk.risk_owner.email << risk.risk_mitigator.email << risk.risk_reviewer.email << risk.submitor.email
    users_email.each_with_index do |email, index|
      RiskMailer.delay.notify_users_about_risk(risk, email, subject_array[index], name="mgmt_review")
    end
  end
end