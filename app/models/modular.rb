# The Modular Model is to track the controller name and action in the application.
class Modular < ActiveRecord::Base
  validates :section_id, presence:true
  validates :model_name, presence:true, :if => Proc.new{|f| f.model_name.blank? }
  validates_format_of :model_name, :with =>/\A(?=.*[a-z])[a-z\d\s]+\Z/i, :if => Proc.new{|f| !f.model_name.blank? }
  validates :action_name, presence:true, :if => Proc.new{|f| f.action_name.blank? }
  validates_format_of :action_name, :with =>/\A[a-z_]+\z/, :if => Proc.new{|f| !f.action_name.blank? }
  validates :model_name, length: { in: 0..52 }, :if => Proc.new{ |f| !f.model_name.blank? }
  validates :action_name, length: { in: 0..52 }, :if => Proc.new{ |f| !f.action_name.blank? }


  #associations
  belongs_to :section
  has_many :privileges
end
