class QuestionType < ActiveRecord::Base
  #publicactivity gem
    #~ include PublicActivity::Model
    #~ tracked owner: ->(controller, model) { controller && controller.current_user }
    #~ tracked ip: ->(controller,model) {controller && controller.current_user.current_sign_in_ip}
  has_many :nc_questions
  validates :name, presence:true, :if => Proc.new{ |f| f.name.blank? }
  validates_format_of :name, :with =>/\A[a-zA-Z\s]+\z/, :if => Proc.new{ |f| !f.name.blank? }
  validates :name, uniqueness:true, :if => Proc.new{ |f| !f.name.blank? }
  validates :name, length: { in: 4..52 }, :if => Proc.new{ |f| !f.name.blank? }
end