class ChecklistRecommendationsController < ApplicationController
	before_filter :current_audit, :company_module_access_check
	before_filter :authorize_auditees, :only => [:auditee_response_create]
	before_filter :authorize_auditees_skip_company_admin, :only => [:auditee_response]
	before_filter :authorize_auditor_skip_company_admin, :only => [:new, :audit_observation]
	before_filter :authorize_auditor, :only => [:create, :update_individual_score, :audit_observation_create]

	require 'date'

 	#new for checklist recommendation
 	def new
		@checklist_recommendation = ChecklistRecommendation.new
		@score = Score.all
 	end

 	#To create checklist recommendation for auditcompliance
	def create
		@checklist_recommendation = ChecklistRecommendation.new(checklist_params)
		checklist_params = @checklist_recommendation.audit_checklist(params)
			checklist_params.each do |check|
				checklist = {}
				checklist[:checklist_recommendation] = check
				@checklist_recommendation = ChecklistRecommendation.where('checklist_id= ? AND checklist_type= ?',checklist[:checklist_recommendation][:checklist_id], checklist[:checklist_recommendation][:checklist_type]).first
				if @checklist_recommendation.nil?
					score = check[:score]
					check.delete("score")
					check[:is_checklist_new] = true
					@checklist_recommendation = ChecklistRecommendation.new(check)
					@checklist_recommendation.recommendation_completed = true unless params[:commit] == 'Save Draft'
					if @checklist_recommendation.save
						@checklist_recommendation.checklist.update_attributes(:score_id => score) if checklist[:checklist_recommendation][:score]
					end
				else
					@checklist_recommendation.recommendation_completed = true unless params[:commit] == 'Save Draft'
					checklist[:checklist_recommendation][:is_checklist_new] = true
					@checklist_recommendation.checklist.update(:score_id => checklist[:checklist_recommendation][:score]) if checklist[:checklist_recommendation][:score]
					checklist[:checklist_recommendation].delete("score")
					@checklist_recommendation.update(checklist[:checklist_recommendation])
				end
			end
			if(params[:commit] == 'Save Draft')
				flash[:notice] = "Recommendation is saved in Draft"
			else
				@checklist_recommendation.checklist_type == 'AuditCompliance' ? flash[:notice] = "Recommendation is scored successfully" : flash[:notice] = "Recommendation is submitted successfully"
			end
			redirect_to new_audit_checklist_recommendation_path
	 end

	#To show auditee response
	def auditee_response
		if @audit.compliance_type == "Compliance"
			@auditee_recommendation = ChecklistRecommendation.where('auditee_id= ?',current_user.id)
			@checklist_recommendations = @audit.auditee_response_compliances(current_user.id)
		else
			@auditee_recommendation = ChecklistRecommendation.where('auditee_id= ?',current_user.id)
			@response_answers = @audit.auditee_response_answers(current_user.id)
		end
	end

	# To show auditor observation page
  def audit_observation
		@pending_observation = @audit.checklist_recommendations.collect {|x| x.is_published}.include?(nil)
		@observation = @audit.checklist_recommendations.map(&:response_completed).include?(true)
		@published_status = AuditStatus.where('name= ?', "Published").first
    if @audit.compliance_type == "Compliance"
      @checklist_recommendations = @audit.audit_observation_compliances
    else
      @observation_answers = @audit.audit_observation_answer
    end
  end

	#To create auditee response for checklist recommendation
	def audit_observation_create
		@checklist_recommendation = ChecklistRecommendation.where('id= ?', params[:checklist_recommendation][:id]).first
		if params[:checklist_recommendation][:attachment].present?
			@checklist_recommendation.attachments.build(attachment_file: params[:checklist_recommendation][:attachment])
			@checklist_recommendation.attachments.last.company_id = current_company.id
			@checklist_recommendation.attachments.last.classified = "Audit Observation"
		end
		@checklist_recommendation.last_step = true
		@checklist_recommendation.is_published = true
		if @checklist_recommendation.update(checklist_params)
			if params[:checklist_recommendation][:remarks].present? && @checklist_recommendation.remark.nil?
				@checklist_recommendation.remark = Comment.new(comment: params[:checklist_recommendation][:remarks])
			else
				@checklist_recommendation.remark.update(comment: params[:checklist_recommendation][:remarks])
			end
		end
		@attachment_error = @checklist_recommendation.errors[:attachments][0] if @checklist_recommendation.errors.present? && @checklist_recommendation.errors[:attachments].present?
		@pending_observation = @audit.checklist_recommendations.collect {|x| x.is_published}.include?(nil)
		respond_to :js
	end

	def auditee_response_create
		@checklist_recommendation = ChecklistRecommendation.where('id= ?', params[:checklist_recommendation][:id]).first
		if params[:checklist_recommendation][:attachment].present?
			@checklist_recommendation.attachments.build(attachment_file: params[:checklist_recommendation][:attachment])
			@checklist_recommendation.attachments.last.company_id = current_company.id
			@checklist_recommendation.attachments.last.classified = "Auditee Response"
		end
		@checklist_recommendation.auditee_id = current_user.id
		@checklist_recommendation.response_completed = true
		@checklist_recommendation.is_checklist_new = true
		@checklist_recommendation.update(checklist_params)
		@attachment_error = @checklist_recommendation.errors[:attachments][0] if @checklist_recommendation.errors.present? && @checklist_recommendation.errors[:attachments].present?
		respond_to :js
	end

	#To create individual checklist recommendation
	def update_individual_score
		@checklist_recommendation = ChecklistRecommendation.where('checklist_id= ? AND checklist_type= ?',params[:checklist_recommendation][:checklist_id], params[:checklist_recommendation][:checklist_type]).first
		score = params[:checklist_recommendation][:score]
		params[:checklist_recommendation].delete("score")
		if @checklist_recommendation.nil?
			@checklist_recommendation = ChecklistRecommendation.new(checklist_params)
			@checklist_recommendation.is_checklist_new = true
			@checklist_recommendation.checklist.update_attributes(:score_id => score) if  @checklist_recommendation.save
		else
			@checklist_recommendation.is_checklist_new = true
			@checklist_recommendation.checklist.update(:score_id => score)
			@checklist_recommendation.update(checklist_params)
		end
	end


 #After observed restrict to create recommendation , response & observed

 # def observed
 #   @checklist_recommendation = ChecklistRecommendation.where('checklist_id= ? AND checklist_type= ?', params[:checklist_recommendation][:checklist_id], params[:checklist_recommendation][:checklist_type]).first
	# 	 unless @checklist_recommendation.is_published
	# 	 	@path = true
	# 	 else
	# 	 	@path = false
	# 		end
	#  	return @path
 #  end

  def remove_attachment
    attachment = Attachment.find(params[:id])
    attachment.delete
  end


	def list_artifacts_and_comments
		@audit_compliance = AuditCompliance.find(params[:id])
		@artifact_answers = @audit_compliance.artifact_answers
   		render layout: false
	end

	def download_artifacts
		attachment = Attachment.find(params[:id])
		send_file(Rails.public_path.to_s + attachment.attachment_file_url)
	end


	private
	  def checklist_params
	    params.require(:checklist_recommendation).permit(:checklist_id, :checklist_type, :auditee_id, :recommendation, :reason, :corrective, :preventive, :closure_date, :recommendation_priority_id, :recommendation_severity_id, :response_priority_id, :response_severity_id, :recommendation_status_id, :response_status_id, :dependent_recommendation, :blocking_recommendation, :observation, :recommendation_completed, :is_implemented,:is_checklist_new)
	  end
end

