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

  def comp_application_rejected_email(comp_application)
    @comp_application = comp_application
    mail(to: @comp_application.user.email,
         subject: t('competition.email.rejected_subject'),
         reply_to: @comp_application.competition.admin_email
    )
  end

end
