class NcQuestion < ActiveRecord::Base

	#Assosciations
	belongs_to :question_type
	belongs_to :priority
	belongs_to :company
	belongs_to :auditee, :class_name => "User", foreign_key: :auditee_id
	belongs_to :audit
	has_many :question_options
	has_one :answer
	has_many :checklist_recommendations, as: :checklist
	accepts_nested_attributes_for :question_options, :allow_destroy => true
  has_one :checklist_recommendation, as: :checklist

	#Validations
	validates :question, presence: true
	validates :target_date, presence: true

  #delegates
  delegate :value, to: :answer, prefix: true, allow_nill: :true
  delegate :detailed_value, to: :answer, prefix: true, allow_nill: :true
  delegate :email, to: :auditee, prefix: true, allow_nill: :true
	delegate :name, to: :question_type, prefix: true, allow_nil: true
  delegate :value, to: :question_options, prefix: true, allow_nil: true
  delegate :name, to: :priority, prefix: true, allow_nil: true
  delegate :title, to: :audit, prefix: true, allow_nil: true
  delegate :user_name, to: :auditee, prefix: true, allow_nil: true

  #scope
  scope :for_auditee, lambda {|auditee_id| where(auditee_id: auditee_id)}

	def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Roo::CSV.new(file.path)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.build_from_import(file, current_company)
    spreadsheet = NcQuestion.open_spreadsheet(file)
    start = 2
    (start..spreadsheet.last_row).each do |i|
      row_data = spreadsheet.row(i)
      question_type = QuestionType.where("lower(name) = ?", "#{row_data[1].to_s.strip.downcase}").first
      nc_question = NcQuestion.new(question: row_data[0].to_s.strip, question_type_id: (question_type.present? ? question_type.id : nil), company_id: current_company.id, nc_library: true)
      nc_question.save(:validate => false)

      if(row_data[2].present? && (options = row_data[2].split(",").compact).present?)
        options.collect{|x| nc_question.question_options.create(value: x.strip) }
      end
    end
  end

  after_create :notify_particular_auditees
  after_update :notify_auditee_about_ncchecklist_update

  def notify_particular_auditees
    ReminderMailer.delay.notify_auditees_that_checklist_is_prepared(self)
  end

  def notify_auditee_about_ncchecklist_update
    ReminderMailer.delay.notify_auditee_about_ncchecklist_update(self)
  end

end
