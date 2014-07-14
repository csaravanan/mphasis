class Subscription < ActiveRecord::Base
	belongs_to :section
	has_many :plans
	has_many :transactions
	validates :section_ids,presence: true
	validates :name, presence:true, :if => Proc.new{|f| f.name.blank? }
	validates_format_of :name, :with =>/\A(?=.*[a-z])[a-z\d\s]+\Z/i, :if => Proc.new{ |f| !f.name.blank? }
	validates :name, uniqueness:true, :if => Proc.new{ |f| !f.name.blank? }
	validates :name, length: { in: 4..50 }, :if => Proc.new{ |f| !f.name.blank? }
	validates :amount, presence: true , :if => Proc.new {|f| f.amount.blank? }
	validates :amount,:numericality => { :greater_than_or_equal_to => 0 }, :if => Proc.new{ |f| !f.amount.blank? }
	validates :valid_log,presence: true, :if => Proc.new {|f| f.valid_log.blank? }
	validates :valid_log,:numericality => { :greater_than_or_equal_to => 1,:less_than_or_equal_to => 500, :only_integer => true  },:if => Proc.new{ |f| !f.valid_log.blank? }
	validates :user_count,presence: true
	validates :file_size,presence: true
	#~ belongs_to :subscription_sections
	
	#~ def subscription_sections
		#~ self.section_ids.collect {|id| Section.find_by_id(id)}
	#~ end
end
