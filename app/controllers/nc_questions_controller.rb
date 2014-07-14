class NcQuestionsController < ApplicationController
  before_filter :current_audit, :company_module_access_check
  #authorize_resource
  before_filter :check_for_auditee_response, :only => [:new]

  # Intialize Nc Questions for audit
  def new
		@nc_question = NcQuestion.new
		@audit.nc_questions.build unless @audit.nc_questions.present?
    @audit.nc_questions.first.question_options.build unless @audit.nc_questions.first.question_options.present?

    # nc_questions from library
    nc_questions = current_company.nc_questions.where(:nc_library => "true")
    audit_nc_questions = @audit.nc_questions.map(&:id)
    @library_questions = audit_nc_questions.compact.blank? ? nc_questions : nc_questions.where("id NOT IN (?)", audit_nc_questions)
	end

  # Create Nc Questions for audit
	def create
		if @audit.update_attributes(question_params)
      @audit.nc_questions.update_all(company_id: current_company.id)
      flash[:notice] = "Your requests were added successfully"
      redirect_to new_audit_nc_question_path
    else
      flash[:error] = "Something went wrong and requests were not added"
			render "new"
		end
	end

	def library_questions
		@nc_questions = NcQuestion.where(:id=>params[:nc_question])
		@priorities = Priority.all
		@response_types = QuestionType.all
		@auditees = @audit.auditees.all
  end

  # Import NcQuestions from CSV file
	def import_files
		if(params[:file].present?)
      begin
				NcQuestion.build_from_import(params[:file], current_company)
        redirect_to new_audit_nc_question_path, :flash => { :notice => MESSAGES["nc_question"]["csv_upload"]["success"]}
      rescue
        redirect_to new_audit_nc_question_path, :flash => { :notice => MESSAGES["csv_upload"]["error"]}
      end
    else
      redirect_to new_audit_nc_question_path , :flash => { :notice => MESSAGES["csv_upload"]["presence"]}
    end
  end

  # Download NcQuestion sample file
  def export_files
    begin
      file_to_download = "sample_non_compliance_question.csv"
      send_file Rails.public_path + file_to_download, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=#{file_to_download}", :stream => true, :buffer_size => 4096
    rescue
      flash[:error] = MESSAGES["csv_export"]["error"]
      redirect_to new_audit_path
    end
  end

  private
    # Strong Parameters for NcQuestions of particular Audit
		def question_params
			params.require(:audit).permit(nc_questions_attributes: [:question, :question_type_id, :priority_id, :target_date, :does_require_document, :nc_library, :auditee_id, :id, :_destroy, question_options_attributes: [:value, :id, :_destroy]])
		end

    # Filter for Authenticate auditee response based on the Audit
    def check_for_auditee_response
      if(@audit.auditees.map(&:id).include?(current_user.id))
        redirect_to new_audit_answers_path(@audit)
      end
    end
end
