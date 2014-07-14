class SubscriptionNotifier < ActionMailer::Base
  default from: "noreply@fixrnix.in"

  def payment_complete(user_email, payment,subscription)
    @payment = payment
    @subscription = subscription
    mail(to: user_email.join(","), subject: 'Subscription Payment Successful',content_type: "text/html")
  end

  def payment_failed(user_email, payment,subscription)
    @payment = payment
    @subscription = subscription
    mail(to: user_email.join(","), subject: 'Subscription Payment Failed.',content_type: "text/html")
  end

  def plan_expire_notification(company, plan)
    @plan = plan
    mail(to: company.join(","), subject: 'Subscription expires today',content_type: "text/html")
  end

  def plan_notification(company, plan)
    @plan = plan
    mail(to: company.join(","), subject: 'Subscription will expire in 2 days',content_type: "text/html")
  end
end
