class ApplicationMailer < ActionMailer::Base
  default from: 'registrations@mondocon.hu'
  layout 'mailer'

  def welcome_email(user)
    @user = user
    @url = 'http://example.com/login'
    mail(to: @user.email, subject: 'Test email from rails')
  end

end
