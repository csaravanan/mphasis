json.data do |json|
  json.array!(@risks) do |risk|
      json.id risk.id
      json.subject risk.subject
      json.status risk.risk_status_name
      if risk.risk_scoring_scoring_type == 'Custom'
        json.risk risk.risk_scoring_custom_value
				json.days_open risk.risk_scoring_custom_value.nil? ? '' : days_open(risk.risk_scoring_custom_value, risk)
      else
        json.risk risk.risk_scoring_calculated_risk
				json.days_open risk.risk_scoring_calculated_risk.nil? ? '' : days_open(risk.risk_scoring_calculated_risk, risk)
      end
      if risk.risk_scoring_scoring_type == 'Custom'
        json.next_review risk.risk_scoring_custom_value.nil? ? '' : next_review_date(risk.risk_scoring_custom_value, risk)
      else
        json.next_review risk.risk_scoring_calculated_risk.nil? ? '' : next_review_date(risk.risk_scoring_calculated_risk, risk)
      end
      json.owner risk.risk_owner_user_name
    end
end