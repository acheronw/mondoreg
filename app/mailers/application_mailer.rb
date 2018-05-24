class ApplicationMailer < ActionMailer::Base
  default from: 'registrations@mondocon.hu'
  layout 'mailer'


  def generate_qr(text)
    require 'barby'
    require 'barby/barcode/qr_code'
    require 'barby/outputter/png_outputter'

    barcode = Barby::QrCode.new(text, level: :q, size: 5)
    base64_output = Base64.encode64(barcode.to_png({ xdim: 5 }))
    return "data:image/png;base64,#{base64_output}"
  end

  def ticket_ordered_email(ticket_order)
      @ticket_order = ticket_order
      mail(to: @ticket_order.user.email, subject: t('ticketing.email.ticket_order_subject'))
  end

  def ticket_confirmed_email(ticket_order)
      @ticket_order = ticket_order
      ticket_url = ticket_order_url(@ticket_order)
      attachments['qr_code.png'] = generate_qr(ticket_url)
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
