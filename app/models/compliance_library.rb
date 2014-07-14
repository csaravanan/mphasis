class ComplianceLibrary < ActiveRecord::Base

 # Relationship
 has_many :operational_areas
 belongs_to :compliance
 has_many :artifacts
 has_many :audit_compliances
 belongs_to :parent , :class_name => "ComplianceLibrary", foreign_key: "parent_id"
 has_many :risks

 #Validations
 validates :compliance_id, presence: true
 validates :name, presence: true

 scope :by_name, lambda { |name| where("lower(name) = ?", name)}

 scope :for_id_and_leaf, lambda { |id| where("compliance_id = ? AND is_leaf is true", id) }

 before_destroy :child_compliance
 before_update :child_compliance_update

 delegate :name, to: :compliance, prefix: true, allow_nil: true
 delegate :parent_id, to: :compliance_library, prefix: true, allow_nil: true

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Roo::CSV.new(file.path)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.build_from_file(file)
    spreadsheet = ComplianceLibrary.open_spreadsheet(file)
    start = 2
    (start..spreadsheet.last_row).each do |i|
      row_data = spreadsheet.row(i)
      compliance = Compliance.by_name(row_data[1].to_s.strip.downcase).first.id
      parent = ComplianceLibrary.by_name(row_data[2].to_s.strip.downcase).first

      compliance_library = ComplianceLibrary.new(:name => row_data[0], :compliance_id => compliance.present? ? compliance : nil, :parent_id => parent.present? ? parent.id : nil, :is_leaf => row_data[3].present? ? true : false)
      compliance_library.save(:validate => false)
    end
  end

  def artifact_lists(current_company_id)
    self.artifacts.where("company_id=? OR company_id is NULL", current_company_id)
  end

 private
 def child_compliance
   control_objectives = ComplianceLibrary.where("parent_id= ?",id)
   control_objectives.each do |object|
      controls = ComplianceLibrary.where('parent_id= ?',object.id)
      controls.collect {|x| x.destroy}
      object.destroy
   end
  end

 def child_compliance_update
   control_objectives = ComplianceLibrary.where("parent_id= ?",id)
     control_objectives.each do |object|
      controls = ComplianceLibrary.where('parent_id= ?',object.id).update_all(compliance_id: compliance_id)
      end
   control_objectives.update_all(compliance_id: compliance_id)
 end

end
