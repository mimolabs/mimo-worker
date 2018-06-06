class SplashMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def invalid_api_token
    @email       = params[:email]
    @location    = params[:location]
    @type        = params[:type]
    mail(to: @email, subject: '[SPLASH] Invalid Newsletter API Token')
  end

  def generic_error
    @email       = params[:email]
    @location    = params[:location]
    @type        = params[:type]
    @error       = params[:error]
    @url         = params[:url]
    mail(to: @email, subject: '[SPLASH] Newsletter Error')
  end

  def daily_password
    @email = params[:email]
    @password = params[:password]
    @location = params[:location_name]
    mail(to: @email, subject: '[SPLASH] Password Changed')
  end
end
