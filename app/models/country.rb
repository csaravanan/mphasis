class Country < ActiveRecord::Base
  has_many :companies # A country has many companies
  has_many :profiles
end
