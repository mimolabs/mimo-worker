class DataRequestMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def delete_request_email
    @email  = params[:email]
    @location_name   = params[:location_name]
    mail(to: @email, subject: '[USER DELETED]')
  end

  def access_request_email
    @email  = params[:email]
    @mailer_data = params[:mailer_data]
    @url = params[:url]
    mail(to: @email, subject: '[USER DATA] Your data request')
  end
end
