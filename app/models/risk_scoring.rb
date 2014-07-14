class RiskScoring < ActiveRecord::Base

	# Associations
	has_many :control_measures
  belongs_to :risk
	belongs_to :scoring, :polymorphic => true

  validates :custom_value, :presence => true, :if => Proc.new{ |f| f.scoring_type == 'Custom' }
  validates :custom_value, :inclusion => {:in => 1..10}, :if => Proc.new{ |f| f.scoring_type == 'Custom' }

  accepts_nested_attributes_for :scoring

  after_create :update_scoring
  after_update :update_scoring

  SCORING_TYPES = [["Classic", "ClassicScoring"], ["OWASP", "OwaspScoring"], ["DREAD", "DreadScoring"], ["CVSS", "CvssScoring"], ["Custom", "Custom"]]

  delegate :risk_model , to: :risk , prefix: true, allow_nil: true

  def attributes=(attributes = {})
    self.scoring_type = attributes[:scoring_type]
    super
  end

  def scoring_attributes=(attributes)
    unless scoring_type == 'Custom'
      if(attributes.include?("id"))
        scoring = eval(scoring_type).find(attributes.delete(:id))
        scoring.try(:assign_attributes, attributes)
        self.scoring = scoring
      else
        self.scoring =  eval(scoring_type).new(attributes)
      end
    end
  end

  def update_scoring
  	if((self.scoring_type_changed? || self.scoring_id_changed?) && self.scoring_type != "Custom")
  		case self.scoring_type
  			when "DreadScoring"
  				self.dread_scoring_method
  			when "OwaspScoring"
  				self.owasp_scoring_method
  			when "CvssScoring"
  				self.cvss_scoring_method
  			else
  				self.classic_scoring_method(self.risk_risk_model.name)
  		end
  	end
  end

  # DREAD Risk Scoring
	def dread_scoring_method
		scoring = self.scoring
		risk_score = (scoring.dread_damage_potential + scoring.dread_reproducibility + scoring.dread_exploitability + scoring.dread_affected_users + scoring.dread_discoverability).to_f / 5
		# self.calculated_risk = risk_score
		self.update_columns(:calculated_risk => risk_score)
	end

	# OWASP Risk Scoring
	def owasp_scoring_method
		scoring = self.scoring
		threat_agent_factor = (scoring.owasp_skill_level + scoring.owasp_motive + scoring.owasp_opportunity + scoring.owasp_size).to_f / 4.0
		vunlnerability_factor = (scoring.owasp_awareness + scoring.owasp_intrusion_detection + scoring.owasp_ease_of_discovery + scoring.owasp_ease_of_exploit).to_f / 4.0
		technical_impact = (scoring.owasp_loss_of_confidentiality + scoring.owasp_loss_of_integrity +  scoring.owasp_loss_of_availability + scoring.owasp_loss_of_accountability).to_f / 4.0
		business_impact = (scoring.owasp_financial_damage + scoring.owasp_reputation_damage + scoring.owasp_non_compliance + scoring.owasp_privacy_violation).to_f / 4.0

		risk_likelihood = ((threat_agent_factor.to_f + vunlnerability_factor.to_f) / 2.0)
		risk_impact = ((technical_impact.to_f + business_impact.to_f) / 2.0)
		risk_score = (risk_likelihood.to_f * risk_impact.to_f) / 10.0

		self.update_columns(:calculated_risk => (risk_score).round(1))
	end


	# CLASSIC Risk Scoring
	def classic_scoring_method(risk_model)
		scoring = self.scoring

		case risk_model
			when "Likelihood * Impact + 2(Impact)"
				risk_score = ((scoring.likelihood.to_f  * scoring.impact.to_f ) + (2 * scoring.impact.to_f )) * (10.0/35.0)
			when "Likelihood * Impact + Impact"
				risk_score = ((scoring.likelihood.to_f  * scoring.impact.to_f ) + scoring.impact.to_f )* (10.0/30.0)
			when "Likelihood * Impact + Likelihood"
				risk_score = ((scoring.likelihood.to_f  * scoring.impact.to_f ) + scoring.likelihood.to_f ) * (10.0/30.0)
			when "Likelihood * Impact + 2(Likelihood)"
				risk_score = ((scoring.likelihood.to_f  * scoring.impact.to_f ) + (2 * scoring.likelihood.to_f ) )  * (10.0/35.0)
			when "Likelihood * Impact"
				risk_score = (scoring.likelihood.to_f  * scoring.impact.to_f ) * (10.0/25.0)
			else
				risk_score = 10
		end

		self.update_columns(:calculated_risk => risk_score.round(1))
	end

	# CVSS Risk Scoring
	 def cvss_scoring_method

		scoring = self.scoring
		impact_score = 10.41 * (1 - ((1- scoring.conf_impact_numeric_value) * (1- scoring.integ_impact_numeric_value) * (1 - scoring.avail_impact_numeric_value)))
		exploitability_score = 20 * scoring.access_complexity_numeric_value * scoring.authentication_numeric_value * scoring.access_vector_numeric_value
		impact_function = impact_score == 0 ? 0 : 1.176
		base_score = (0.6 * impact_score + (0.4 * exploitability_score) * 1.5) * impact_function
		temporal_score = base_score * scoring.exploitability_numeric_value * scoring.remediation_level_numeric_value * scoring.report_confidence_numeric_value
		env_score = ((temporal_score + (10 - temporal_score) * scoring.collateral_damage_potential_numeric_value ))* scoring.target_distribution_numeric_value

		if scoring.collateral_damage_potential_numeric_value == -1 && scoring.target_distribution_numeric_value == -1
			if scoring.exploitability_numeric_value == -1 && scoring.remediation_level_numeric_value == -1 && scoring.report_confidence_numeric_value == 0
				risk_score = base_score
			else
				risk_score = temporal_score
			end
		else
			risk_score = env_score
		end
		self.update_columns(:calculated_risk => (risk_score).round(2))
	 end

end
