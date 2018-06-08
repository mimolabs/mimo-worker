class PersonDeleteMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def person_delete_request_email
    @email  = params[:email]
    @location_name   = params[:location_name]
    mail(to: @email, subject: '[USER DELETED]')
  end
end
