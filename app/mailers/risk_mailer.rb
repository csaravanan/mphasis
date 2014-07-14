class RiskMailer < ActionMailer::Base
  default from: "noreply@fixrnix.in"

  def notify_users_about_risk(risk, email, subject, name)
    @risk = risk
    @name = name
    mail(:to => email, content_type: "text/html", :subject => "#{subject}" )
  end

  def risk_review_notify(risk, review_days)
    @risk = risk
    @days = review_days
    mail(:to => risk.risk_reviewer.email, content_type: "text/html", :subject => "Your next review date for #{risk.subject} is approaching."  )
  end
end