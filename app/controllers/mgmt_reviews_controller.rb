class MgmtReviewsController < ApplicationController
	layout "risk_layout"
	before_filter :current_risk, :company_module_access_check
	# before_filter :authorize_mgmt_review, :only => [:new, :create, :edit, :update]
	before_filter :reviews_and_next_steps, only: [:new, :create, :edit, :update]

	def new
		@mgmt_review = @risk.mgmt_review.present? ? @risk.mgmt_review : @risk.build_mgmt_review

	end

	def create
		@mgmt_review = @risk.build_mgmt_review(mgmt_review_params)
		@mgmt_review.reviewer = current_user
		risk_status = params[:mgmt_review][:review_id].to_i == 1 ? RiskStatus.where("name= ?", "Reviewed").first.id : RiskStatus.where("name= ?", "Rejected").first.id
		if @mgmt_review.save
			@risk.update(risk_status_id: risk_status, review_date: Date.today)
			flash[:notice] = "Risk is reviewed successfully"
			redirect_to edit_risk_mgmt_review_path(id: @mgmt_review)
		else
			render "new"
		end
	end

	def edit
		@mgmt_review = @risk.mgmt_review
	end


	def update
		@mgmt_review = @risk.mgmt_review
		risk_status = params[:mgmt_review][:review_id].to_i == 1 ? RiskStatus.where("name= ?", "Reviewed").first.id : RiskStatus.where("name= ?", "Rejected").first.id
		if @mgmt_review.update(mgmt_review_params)
			@risk.update(risk_status_id: risk_status, review_date: Date.today)
			flash[:notice] = "Management Review is Updated"
			redirect_to edit_risk_mgmt_review_path(id: @mgmt_review)
		else
			render "edit"
		end
	end



	private
		def mgmt_review_params
			params.require(:mgmt_review).permit(:review_id, :reviewer, :next_step_id, comment_attributes: [:id, :comment])
		end

		def authorize_mgmt_review
	    if ((current_risk.mitigator != current_user.id) && (current_risk.submitted_by != current_user.id))
	      flash[:alert] = "Access restricted"
	      redirect_to risks_path
	    end
	  end

	  def reviews_and_next_steps
	  	@review = Review.all
			@next_step = NextStep.all
			if @risk.control_measure.present?
				@processes = CppMeasure.where(id: @risk.control_measure.process_ids)
				@controls = CppMeasure.where(id: @risk.control_measure.control_ids)
				@procedures = CppMeasure.where(id: @risk.control_measure.procedure_ids)
			end
		end
end