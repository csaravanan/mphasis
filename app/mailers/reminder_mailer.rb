class ReminderMailer < ActionMailer::Base

  default from: "noreply@fixrnix.in"

  def notify_auditor_about_audit(audit)
  	@audit = audit
  	mail(:to => audit.auditory_email, content_type: "text/html", :subject => "Your Audit has been successfully created" )
  end

  def notify_auditees_about_audit(audit)
  	@audit = audit
  	mail(:to => audit.auditees.map(&:email), :subject => "You have been invited to an audit", content_type: "text/html")
  end

  def notify_auditees_that_checklist_is_prepared(nc_question)
    @nc_question = nc_question
    mail(:to => nc_question.auditee_email, :subject => "Checklist has been prepared for NonCompliance Audit", content_type: "text/html") if nc_question.auditee
  end

   def notify_auditee_about_ncchecklist_update(nc_question)
    @nc_question = nc_question
    mail(:to => nc_question.auditee_email, :subject => "Checklist has been updated for NonCompliance Audit", content_type: "text/html")
  end

  def notify_auditee_about_checklist(artifact_answer)
    @artifact_answer = artifact_answer
    mail(:to => artifact_answer.responsibility_email, :subject => "Checklist has been prepared for Compliance Audit", content_type: "text/html")
  end

  def notify_auditee_about_checklist_update(artifact_answer)
    @artifact_answer = artifact_answer
    mail(to: artifact_answer.responsibility_email, subject: "Checklist has been updated")
  end

  def notify_auditee_about_recommendations(checklist_recommendation, action)
    @checklist_recommendation = checklist_recommendation
    if checklist_recommendation.checklist_type == "AuditCompliance"
      email = checklist_recommendation.checklist.artifact_answers.last.responsibility_email
    elsif checklist_recommendation.checklist_type == "Answer"
      email = checklist_recommendation.checklist.nc_question.auditee_email
    end
    subject_for_auditee = action == "created" ? "Auditor has given a recommendation" : "Auditor has updated recommendation"
    mail(:to => email , :subject => "#{subject_for_auditee}", content_type: "text/html")
  end

  def notify_auditor_about_responses(checklist_recommendation, action)
    @checklist_recommendation = checklist_recommendation
    if checklist_recommendation.checklist_type == "AuditCompliance"
      email = checklist_recommendation.checklist.audit.auditory_email
    elsif checklist_recommendation.checklist_type == "Answer"
      email = checklist_recommendation.checklist.nc_question.audit.auditory_email
    end
    subject_for_auditor = action == "created" ? "Auditee has submitted a response to your recommendation" : "Auditee has updated response to your recommendation"
    mail(:to => email, :subject => "#{subject_for_auditor}", content_type: "text/html")
  end

  def notify_auditee_about_observations(checklist_recommendation, action)
    @checklist_recommendation = checklist_recommendation
    subject_for_auditee = action == "created" ? "Auditor has submitted an observation for your response" : "Auditor has updated an observation for your response"
    mail(:to => checklist_recommendation.auditee_email, :subject => "#{subject_for_auditee}",content_type: "text/html")
  end

  # Mailer for Artifact Priority
  def artifacts_reminder(answered_artifact, user)
    @answered_artifact = answered_artifact
    @user = user
    mail(:to => user.email, :subject => "Alert mail for submitting your artifacts",content_type: "text/html")
  end

  # Mailer for NC Questions Priority
  def ncquestion_reminder(nc_question, user)
    @nc_question = nc_question
    @user = user
    mail(:to => user.email, :subject => "Alert mail for Answering",content_type: "text/html")

  end

  # Mailer for Recommendation Priority
  def recommendation_reminder(recommendation, user)
    @recommendation = recommendation
    @user = user
    mail(:to => user.email, :subject => "Alert mail for giving response", content_type: "text/html")
  end

  # Mailer for Escalation Matrix
  def escalation_mail_arifact_answer(reminder_mail_to, reminder_mail_cc,answered_artifacts,user)
    @answered_artifact = answered_artifacts
    @user = user
    mail(to: reminder_mail_to, cc: reminder_mail_cc , subject: "Escalation for giving response",content_type: "text/html")
  end

  def escalation_mail_recommendation(reminder_mail_to, reminder_mail_cc,recommendation,user)
    @recommendation = recommendation
    @user = user
    mail(to: reminder_mail_to, cc: reminder_mail_cc , subject: "Escalation for giving response", content_type: "text/html")
  end

  def escalation_mail_nc_questions(reminder_mail_to, reminder_mail_cc,nc_question,user)
    @nc_question = nc_question
    @user = user
    mail(to: reminder_mail_to, cc: reminder_mail_cc , subject: "Escalation for giving response", content_type: "text/html")
  end

end
