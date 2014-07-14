class CvssMetricScoring < ActiveRecord::Base

    # Assosciations
    scope :for_name, lambda {|metric_name| where(metric_name: metric_name)}

end
