namespace :reminder do
  desc "Reminders"
  task notify: :environment do
    company = Company.active
    company.each do |company|
      audit = company.active_audits_with_skipped
      audit.each do |audit|

        # Artificats Remainders
        # logger.info("Aritifacts Remainder")
         audit.unanswered_artifacts.each do |answered_artifacts|
            if(reminder = Reminder.check_priority(company.id, answered_artifacts.priority_id))
              user = answered_artifacts.responsibility
              if ReminderMailer.artifacts_reminder(answered_artifacts, user).deliver
                if(ReminderMail.escalation_matrix("ArtifactAnswer", answered_artifacts.id, reminder.mail_count))
                  reminder_mail_to,reminder_mail_cc = reminder.get_escalation_mails(company,user,audit)
                  ReminderMailer.escalation_mail_arifact_answer(reminder_mail_to, reminder_mail_cc,answered_artifacts,user).deliver
                end
              end
            end
         end

        #Checlist Recommendation Reminders
        # logger.info "Checklist Recommendation Reminder"
        audit.unresponsive_recommendation.each do |recommendation|
          if( reminder = Reminder.check_priority(company.id,recommendation.recommendation_priority_id))
            if recommendation.checklist_type == "AuditCompliance"
              user = recommendation.checklist.artifact_answers.last.responsibility
            else
              user = recommendation.checklist.nc_question.auditee
            end
            if ReminderMailer.recommendation_reminder(recommendation, user).deliver
              if(ReminderMail.escalation_matrix("ChecklistRecommendation", recommendation.id, reminder.mail_count))
                reminder_mail_to,reminder_mail_cc = reminder.get_escalation_mails(company,user,audit)
                ReminderMailer.escalation_mail_recommendation(reminder_mail_to, reminder_mail_cc,recommendation,user).deliver
              end
            end
          end
        end

        # Non Compliance Reminders
        # logger.info "Non Compliance Reminder"
        audit.unanswered_nc_questions.each do |nc_question|
          if (reminder = Reminder.check_priority(company.id,nc_question.priority_id))
            user = nc_question.auditee
            if ReminderMailer.ncquestion_reminder(nc_question ,user).deliver
              if(ReminderMail.escalation_matrix("NcQuestion", nc_question.id, reminder.mail_count))
                reminder_mail_to,reminder_mail_cc = reminder.get_escalation_mails(company,user,audit)
                ReminderMailer.escalation_mail_nc_questions(reminder_mail_to, reminder_mail_cc,nc_question,user).deliver
              end
            end
          end
        end

      end
    end
  end
end