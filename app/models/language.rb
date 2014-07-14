class Language < ActiveRecord::Base
  has_many :users

  scope :current_user_language, ->(id) {where("id = ?", id)}

  validates :name, presence:true , :if => Proc.new{|f| f.name.blank? }
  validates :name, uniqueness:true, :if => Proc.new{|f| !f.name.blank? }
  validates_format_of :name, :with =>/\A[a-zA-Z]+\z/, :if => Proc.new{|f| !f.name.blank? }
  validates :code, presence:true, :if => Proc.new{|f| f.code.blank? }
  validates :code, uniqueness:true, :if => Proc.new{|f| !f.code.blank? }
  validates_format_of :code, :with =>/\A[a-zA-Z]+\z/, :if => Proc.new{|f| !f.code.blank? }
  validates :code, length: { is: 2}, :if => Proc.new{|f| !f.code.blank? }
  validates :name, length: { in: 3..52 }, :if => Proc.new{ |f| !f.name.blank? }

end