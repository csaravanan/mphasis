class Priority < ActiveRecord::Base

# Relationship
  has_many :nc_questions
  has_many :checklist_recommendations
  has_many :artifact_answers
  has_many :reminders

  # Validation
  validates :name, presence: true, :if => Proc.new{ |f| f.name.blank? }
  validates_format_of :name, :with =>/\A(?=.*[a-z])[a-z\d\s]+\Z/i, :if => Proc.new{ |f| !f.name.blank? }
  validates :name, uniqueness: true, :if => Proc.new{ |f| !f.name.blank? }
end