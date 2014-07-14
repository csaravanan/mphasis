class AuditAuditee < ActiveRecord::Base
  belongs_to :audit
  belongs_to :user
end
