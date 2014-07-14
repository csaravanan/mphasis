class ClassicScoringMetric < ActiveRecord::Base

  # Scopes
  scope :for_name, lambda {|metric_type| where(metric_type: metric_type)}

end
