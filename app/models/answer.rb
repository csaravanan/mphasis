class Answer < ActiveRecord::Base

	has_one :checklist_recommendation, as: :checklist
	belongs_to :nc_question
  has_one :question_type , through: :nc_question
	has_one :attachment , as: :attachable
  belongs_to :question_option, :class_name => "QuestionOption", foreign_key: "value"

  delegate :question, :to => :nc_question, allow_nil: true
  delegate :name, :to => :question_type, prefix: true, allow_nil: true

  # validates :value, presence: true, :if => Proc.new{|f|  f.nc_question.does_require_document == true }
  # validates :detailed_value, presence:true
  # validates :value, presence:true
  # Build Answer form Nc Question selected
  def self.build_answer(params, company)
    errors = {}
    params[:answer] && params[:answer].each do |nc_id, answer|
        # attachment = answer.delete("attachment")
        nc_que = NcQuestion.where(id: nc_id).last
        unless nc_que.answer.present?
            answer_val = {}
            answer_val[:value] = answer[:value].present? ? answer[:value] : answer[:detailed_value]
            answer_val[:nc_question_id] = nc_que.id
            Answer.new(answer_val).save
            nc_que.reload
            if params[:commit] == "Submit Answers to Auditor"
              nc_que.is_answered = true
             if nc_que.save
                answer_attachment = nc_que.answer.attachment.nil? ? nc_que.answer.build_attachment : nc_que.answer.attachment
                answer_attachment.company_id = company.id
                answer_attachment.update(attachment_file: answer[:attachment]) if answer[:attachment].present?
                errors = answer_attachment.errors if answer_attachment.errors.present?
             end
            end
        else
            answer_val = {}
            answer_val[:value] = answer[:value].present? ? answer[:value] : answer[:detailed_value]
            if nc_que.answer.update(answer_val)
              if params[:commit] == "Submit Answers to Auditor"
                nc_que.is_answered = true
                nc_que.save
                errors = nc_que.errors[:"attachment"] if nc_que.errors.present? && nc_que.errors[:"attachment"].present? 
            end
              answer_attachment = nc_que.answer.attachment.nil? ? nc_que.answer.build_attachment : nc_que.answer.attachment
              answer_attachment.company_id = company.id
              answer_attachment.update(attachment_file: answer[:attachment]) if answer[:attachment].present?
              errors = answer_attachment.errors if answer_attachment.errors.present?
            end
        end
    end
      return errors[:''].nil? ? nil : errors
  end
end
