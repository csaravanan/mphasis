class Company < ActiveRecord::Base
  TIMEZONES = [["(GMT-11:00) American Samoa", "American Samoa"], ["(GMT-11:00) International Date Line West", "International Date Line West"], ["(GMT-11:00) Midway Island", "Midway Island"], ["(GMT-10:00) Hawaii", "Hawaii"], ["(GMT-09:00) Alaska", "Alaska"], ["(GMT-08:00) Pacific Time (US &amp; Canada)", "Pacific Time (US &amp; Canada)"], ["(GMT-08:00) Tijuana", "Tijuana"], ["(GMT-07:00) Arizona", "Arizona"], ["(GMT-07:00) Chihuahua", "Chihuahua"], ["(GMT-07:00) Mazatlan", "Mazatlan"], ["(GMT-07:00) Mountain Time (US &amp; Canada)", "Mountain Time (US &amp; Canada)"], ["(GMT-06:00) Central America", "Central America"], ["(GMT-06:00) Central Time (US &amp; Canada)", "Central Time (US &amp; Canada)"], ["(GMT-06:00) Guadalajara", "Guadalajara"], ["(GMT-06:00) Mexico City", "Mexico City"], ["(GMT-06:00) Monterrey", "Monterrey"], ["(GMT-06:00) Saskatchewan", "Saskatchewan"], ["(GMT-05:00) Bogota", "Bogota"], ["(GMT-05:00) Eastern Time (US &amp; Canada)", "Eastern Time (US &amp; Canada)"], ["(GMT-05:00) Indiana (East)", "Indiana (East)"], ["(GMT-05:00) Lima", "Lima"], ["(GMT-05:00) Quito", "Quito"], ["(GMT-04:30) Caracas", "Caracas"], ["(GMT-04:00) Atlantic Time (Canada)", "Atlantic Time (Canada)"], ["(GMT-04:00) Georgetown", "Georgetown"], ["(GMT-04:00) La Paz", "La Paz"], ["(GMT-04:00) Santiago", "Santiago"], ["(GMT-03:30) Newfoundland", "Newfoundland"], ["(GMT-03:00) Brasilia", "Brasilia"], ["(GMT-03:00) Buenos Aires", "Buenos Aires"], ["(GMT-03:00) Greenland", "Greenland"], ["(GMT-03:00) Montevideo", "Montevideo"], ["(GMT-02:00) Mid-Atlantic", "Mid-Atlantic"], ["(GMT-01:00) Azores", "Azores"], ["(GMT-01:00) Cape Verde Is.", "Cape Verde Is."], ["(GMT+00:00) Casablanca", "Casablanca"], ["(GMT+00:00) Dublin", "Dublin"], ["(GMT+00:00) Edinburgh", "Edinburgh"], ["(GMT+00:00) Lisbon", "Lisbon"], ["(GMT+00:00) London", "London"], ["(GMT+00:00) Monrovia", "Monrovia"], ["(GMT+00:00) UTC", "UTC"], ["(GMT+01:00) Amsterdam", "Amsterdam"], ["(GMT+01:00) Belgrade", "Belgrade"], ["(GMT+01:00) Berlin", "Berlin"], ["(GMT+01:00) Bern", "Bern"], ["(GMT+01:00) Bratislava", "Bratislava"], ["(GMT+01:00) Brussels", "Brussels"], ["(GMT+01:00) Budapest", "Budapest"], ["(GMT+01:00) Copenhagen", "Copenhagen"], ["(GMT+01:00) Ljubljana", "Ljubljana"], ["(GMT+01:00) Madrid", "Madrid"], ["(GMT+01:00) Paris", "Paris"], ["(GMT+01:00) Prague", "Prague"], ["(GMT+01:00) Rome", "Rome"], ["(GMT+01:00) Sarajevo", "Sarajevo"], ["(GMT+01:00) Skopje", "Skopje"], ["(GMT+01:00) Stockholm", "Stockholm"], ["(GMT+01:00) Vienna", "Vienna"], ["(GMT+01:00) Warsaw", "Warsaw"], ["(GMT+01:00) West Central Africa", "West Central Africa"], ["(GMT+01:00) Zagreb", "Zagreb"], ["(GMT+02:00) Athens", "Athens"], ["(GMT+02:00) Bucharest", "Bucharest"], ["(GMT+02:00) Cairo", "Cairo"], ["(GMT+02:00) Harare", "Harare"], ["(GMT+02:00) Helsinki", "Helsinki"], ["(GMT+02:00) Istanbul", "Istanbul"], ["(GMT+02:00) Jerusalem", "Jerusalem"], ["(GMT+02:00) Kyiv", "Kyiv"], ["(GMT+02:00) Pretoria", "Pretoria"], ["(GMT+02:00) Riga", "Riga"], ["(GMT+02:00) Sofia", "Sofia"], ["(GMT+02:00) Tallinn", "Tallinn"], ["(GMT+02:00) Vilnius", "Vilnius"], ["(GMT+03:00) Baghdad", "Baghdad"], ["(GMT+03:00) Kuwait", "Kuwait"], ["(GMT+03:00) Minsk", "Minsk"], ["(GMT+03:00) Nairobi", "Nairobi"], ["(GMT+03:00) Riyadh", "Riyadh"], ["(GMT+03:30) Tehran", "Tehran"], ["(GMT+04:00) Abu Dhabi", "Abu Dhabi"], ["(GMT+04:00) Baku", "Baku"], ["(GMT+04:00) Moscow", "Moscow"], ["(GMT+04:00) Muscat", "Muscat"], ["(GMT+04:00) St. Petersburg", "St. Petersburg"], ["(GMT+04:00) Tbilisi", "Tbilisi"], ["(GMT+04:00) Volgograd", "Volgograd"], ["(GMT+04:00) Yerevan", "Yerevan"], ["(GMT+04:30) Kabul", "Kabul"], ["(GMT+05:00) Islamabad", "Islamabad"], ["(GMT+05:00) Karachi", "Karachi"], ["(GMT+05:00) Tashkent", "Tashkent"], ["(GMT+05:30) Chennai", "Chennai"], ["(GMT+05:30) Kolkata", "Kolkata"], ["(GMT+05:30) Mumbai", "Mumbai"], ["(GMT+05:30) New Delhi", "New Delhi"], ["(GMT+05:30) Sri Jayawardenepura", "Sri Jayawardenepura"], ["(GMT+05:45) Kathmandu", "Kathmandu"], ["(GMT+06:00) Almaty", "Almaty"], ["(GMT+06:00) Astana", "Astana"], ["(GMT+06:00) Dhaka", "Dhaka"], ["(GMT+06:00) Ekaterinburg", "Ekaterinburg"], ["(GMT+06:30) Rangoon", "Rangoon"], ["(GMT+07:00) Bangkok", "Bangkok"], ["(GMT+07:00) Hanoi", "Hanoi"], ["(GMT+07:00) Jakarta", "Jakarta"], ["(GMT+07:00) Novosibirsk", "Novosibirsk"], ["(GMT+08:00) Beijing", "Beijing"], ["(GMT+08:00) Chongqing", "Chongqing"], ["(GMT+08:00) Hong Kong", "Hong Kong"], ["(GMT+08:00) Krasnoyarsk", "Krasnoyarsk"], ["(GMT+08:00) Kuala Lumpur", "Kuala Lumpur"], ["(GMT+08:00) Perth", "Perth"], ["(GMT+08:00) Singapore", "Singapore"], ["(GMT+08:00) Taipei", "Taipei"], ["(GMT+08:00) Ulaanbaatar", "Ulaanbaatar"], ["(GMT+08:00) Urumqi", "Urumqi"], ["(GMT+09:00) Irkutsk", "Irkutsk"], ["(GMT+09:00) Osaka", "Osaka"], ["(GMT+09:00) Sapporo", "Sapporo"], ["(GMT+09:00) Seoul", "Seoul"], ["(GMT+09:00) Tokyo", "Tokyo"], ["(GMT+09:30) Adelaide", "Adelaide"], ["(GMT+09:30) Darwin", "Darwin"], ["(GMT+10:00) Brisbane", "Brisbane"], ["(GMT+10:00) Canberra", "Canberra"], ["(GMT+10:00) Guam", "Guam"], ["(GMT+10:00) Hobart", "Hobart"], ["(GMT+10:00) Melbourne", "Melbourne"], ["(GMT+10:00) Port Moresby", "Port Moresby"], ["(GMT+10:00) Sydney", "Sydney"], ["(GMT+10:00) Yakutsk", "Yakutsk"], ["(GMT+11:00) New Caledonia", "New Caledonia"], ["(GMT+11:00) Solomon Is.", "Solomon Is."], ["(GMT+11:00) Vladivostok", "Vladivostok"], ["(GMT+12:00) Auckland", "Auckland"], ["(GMT+12:00) Fiji", "Fiji"], ["(GMT+12:00) Kamchatka", "Kamchatka"], ["(GMT+12:00) Magadan", "Magadan"], ["(GMT+12:00) Marshall Is.", "Marshall Is."], ["(GMT+12:00) Wellington", "Wellington"], ["(GMT+12:45) Chatham Is.", "Chatham Is."], ["(GMT+13:00) Nuku'alofa", "Nuku'alofa"], ["(GMT+13:00) Samoa", "Samoa"], ["(GMT+13:00) Tokelau Is.", "Tokelau Is."]]

  # associations
  has_many :roles
  has_many :locations
  belongs_to :country # Company belongs to a country
  has_many :audits
  has_many :users
  has_many :teams
  has_many :departments, through: :locations
  has_many :risk_categories
  has_many :nc_questions
  has_one :attachment, :as => :attachable
  has_many :uploads, :class_name => "Attachment", foreign_key: "company_id"
  has_many :operational_areas
  has_many :artifacts
  has_many :reminders
  has_many :clients
  has_one :company_admin, -> { where role_id: Role.where(title: 'company_admin').first.id }, class_name: 'User'
  has_many :technologies
  has_many :risk_review_levels

  # Associations with Risk table
  has_many :risks
  has_many :projects
  has_many :cpp_measures
  has_one :risk_review_level
  has_one :plan
  has_many :subscriptions,through: :plan
  has_many :transactions
  #has_many :company_payments

  accepts_nested_attributes_for :attachment, reject_if: lambda { |a| a[:attachment_file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :plan

  #validations
  validates :name, presence: true
  validates_format_of :name, :with =>/\A(?=.*[a-z])[a-z\d\s]+\Z/i, :if => Proc.new{|f| !f.name.blank? }
  validates :domain, presence: true
  validates :domain, uniqueness: true
  validates_format_of :domain, :with =>/\A[a-z]+\z/
  validates :domain,length: { in: 2..25 }
  validates :name, length: { in: 2..50 }, :if => Proc.new{|f| !f.name.blank? }
  validates_format_of :secondary_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :if => Proc.new{|f| !f.secondary_email.blank? }
  validates_format_of :primary_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :if => Proc.new{|f| !f.primary_email.blank? }
  validates_numericality_of :contact_no, :if => Proc.new{|f| !f.contact_no.blank? }
  validates :contact_no, length: { is: 10},:if => Proc.new{|f| !f.contact_no.blank? }
  validates :address1, length: { in: 7..40 }, :if => Proc.new{|f| !f.address1.blank? }
  validates :address2, length: { in: 7..40 }, :if => Proc.new{|f| !f.address2.blank? }
  validates_exclusion_of :secondary_email, :in => :primary_email , :if => Proc.new{|f| !f.secondary_email.blank? }

  delegate :email, to: :company_admin, prefix: true, allow_nil: true

  attr_accessor :subscription
  after_create :company_role_create, :review_rating_levels_create

  scope :active, -> { where(is_disabled: false) }
  # def active_audits
  #   self.audits.where("end_date <= ?", Date.today)
  # end

  def active_audits_with_skipped
    self.audits.where("end_date >= ?", Date.today) - SkippedAuditReminder.audits
  end

  private
  def company_role_create
    company = Company.last
    Role.create(title: "auditor", company_id: company.id)
    Role.create(title: "auditee", company_id: company.id)
    Role.create(title: "CRO", company_id: company.id)
    Role.create(title: "riskowner", company_id: company.id)
    Role.create(title: "mitigator", company_id: company.id)
    Role.create(title: "reviewer", company_id: company.id)
  end

  def review_rating_levels_create
    company = Company.last
    RiskReviewLevel.create(name: "HIGH", days: 90,value: 7 ,company_id: company.id)
    RiskReviewLevel.create(name: "MEDIUM", days: 180,value: 4 ,company_id: company.id)
    RiskReviewLevel.create(name: "LOW", days: 360,value: 0 ,company_id: company.id)
  end
end
