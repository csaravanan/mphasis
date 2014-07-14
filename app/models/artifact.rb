class Artifact < ActiveRecord::Base

   include PublicActivity::Model
     tracked owner: ->(controller, model) { controller && controller.current_user }
     tracked ip: ->(controller,model) {controller && controller.current_user.current_sign_in_ip}


  # Relationship
  belongs_to :compliance_library
  belongs_to :company
  has_many :artifact_answers

  delegate :name, to: :compliance_library, prefix: true, allow_nil: true
end
