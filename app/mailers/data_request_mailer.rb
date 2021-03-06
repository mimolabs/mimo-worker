class DataRequestMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def delete_request_email
    @email  = params[:email]
    @location_name   = params[:location_name]
    mail(to: @email, subject: '[USER DELETED]')
  end

  def access_request_email
    @email  = params[:email]
    @metadata = params[:metadata]
    @url = params[:url]
    mail(to: @email, subject: '[USER DATA] Your data request')
  end

  def data_download
    @email = params[:email]
    attachments[params[:zip]] = File.read("/tmp/#{params[:zip]}")
    mail(to: @email, subject: '[USER DATA] Your data report')
  end
end