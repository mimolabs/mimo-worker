class EmailMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def double_opt_in_email
    @email  = params[:email]
    @link   = params[:link]
    mail(to: @email, subject: '[CONFIRM] Please Confirm Your Email')
  end
end
