class Technology < ActiveRecord::Base

  # Associations
  has_many :risks
  belongs_to :company

  # Scopes
  scope :for_company, lambda {|id| where(:company_id => [id, nil] ) }
  scope :for_name, lambda { |technology_name| where("lower(name)=?", technology_name) }

  # Validations
  validates :name, presence:true
  validates :name, :uniqueness => {:scope => :company_id}, :if => Proc.new{ |f| !f.name.blank? }

end
