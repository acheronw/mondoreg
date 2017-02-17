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
end
