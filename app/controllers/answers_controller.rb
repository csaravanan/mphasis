class AnswersController < ApplicationController
  before_filter :current_audit
  before_filter :authorize_auditees, :only => [:new]
  before_filter :authorize_auditees_skip_company_admin, :only => [:new]

  # Initialize answer for nc_question belongs to audit
  def new
    @current_auditee_nc_questions = @audit.nc_questions.for_auditee(current_user.id)
  end

  # Create answer for nc_question belongs to audit
  def create
    @answer_errors = Answer.build_answer(params, current_company)
    unless @answer_errors.nil? 
      redirect_to new_audit_answers_path(@audit) , :flash => { :error => @answer_errors[:"file_size_exceeds"][0]}
    else
      redirect_to new_audit_answers_path(@audit) #, :flash => { :error => @answer_errors[:"file_size_exceeds"][0]}
    end
  end

end
