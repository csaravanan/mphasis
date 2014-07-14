class ClassicScoring < ActiveRecord::Base
	
	has_one :risk_scoring , as: :scoring
	belongs_to :classic_likelihood, :class_name => "ClassicScoringMetric", foreign_key: "likelihood"
	belongs_to :classic_impact, :class_name => "ClassicScoringMetric", foreign_key: "impact"
	belongs_to :classic_velocity, :class_name => "ClassicScoringMetric", foreign_key: "velocity"
	belongs_to :classic_vulnerability, :class_name => "ClassicScoringMetric", foreign_key: "vulnerability"
	
end
