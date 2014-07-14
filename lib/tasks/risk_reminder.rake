namespace :reminder do
  desc "Reminders"
  task risk_notification: :environment do
    company = Company.active
    company.each do |company|
      risks = company.risks.collect{|x| x if x.review_date.present?}.compact
      risks && risks.each do |risk|
        calculated_value = (risk.risk_scoring.calculated_risk || risk.risk_scoring.custom_value)

        high_risk = company.risk_review_levels.first
        medium_risk = company.risk_review_levels.second
        low_risk = company.risk_review_levels.third

        if (calculated_value > high_risk.value)
          review_days = high_risk.days
          RiskMailer.delay.risk_review_notify(risk, review_days) if ((risk.review_date + review_days) - 2 == Date.today)
        elsif (calculated_value <= high_risk.value && calculated_value > medium_risk.value)
          medium_risk.days
          review_days = medium_risk.days
          RiskMailer.delay.risk_review_notify(risk, review_days) if ((risk.review_date + review_days) - 2 == Date.today)
        elsif (calculated_value <= medium_risk.value)
          review_days = low_risk.days
          RiskMailer.delay.risk_review_notify(risk, review_days) if ((risk.review_date + review_days) - 2 == Date.today)
        end
      end
    end
  end
end