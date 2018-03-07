class ApplicationMailer < ActionMailer::Base
  default from: 'registrations@mondocon.hu'
  layout 'mailer'

  def ticket_ordered_email(ticket_order)
      @ticket_order = ticket_order
      mail(to: @ticket_order.user.email, subject: t('ticketing.email.ticket_order_subject'))
  end

  def ticket_confirmed_email(ticket_order)
      @ticket_order = ticket_order
      mail(to: @ticket_order.user.email, subject: t('ticketing.email.accepted_subject'))
  end

  def comp_application_confirmed_email(comp_application)
    @comp_application = comp_application
    mail(to: @comp_application.user.email,
         subject: t('competition.email.accepted_subject'),
         reply_to: @comp_application.competition.admin_email
    )
  end

  def cosplay_comp_application_confirmed_email(comp_application)
    @comp_application = comp_application
    attachments.inline["cosplay_infosheet.jpg"] =
        case comp_application.competition.subtype
          when 'craft' then File.read(Rails.root.join("app/assets/images/cosplay_confirmation_craft_info.jpg"))
          when 'craft_group' then File.read(Rails.root.join("app/assets/images/cosplay_confirmation_craft_info.jpg"))
          when 'eurocosplay' then File.read(Rails.root.join("app/assets/images/cosplay_confirmation_eurocosplay_info.jpg"))
          when 'perf' then File.read(Rails.root.join("app/assets/images/cosplay_confirmation_perf_info.jpg"))
          when 'perf_group' then File.read(Rails.root.join("app/assets/images/cosplay_confirmation_perf_info.jpg"))
        end
    mail(to: @comp_application.user.email,
         subject: t('competition.email.accepted_subject'),
         reply_to: @comp_application.competition.admin_email
    )



  end

  def comp_application_rejected_email(comp_application)
    @comp_application = comp_application
    mail(to: @comp_application.user.email,
         subject: t('competition.email.rejected_subject'),
         reply_to: @comp_application.competition.admin_email
    )
  end

end
