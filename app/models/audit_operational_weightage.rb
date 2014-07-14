class AuditOperationalWeightage < ActiveRecord::Base

 # Relationship
 belongs_to :operational_area
 belongs_to :audit
end
