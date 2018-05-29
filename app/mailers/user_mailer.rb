# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email
    @user = params[:user]
    @url  = 'http://example.com/login'
    mail(to: @user, subject: 'Welcome to My Awesome Site')
  end

  def new_devices_imported
    @type = params[:type]
    @email = params[:email]
    @device_count = params[:device_count]
    @location_name = params[:location_name]
    mail(to: @email, subject: '[NEW DEVICES] We\'ve imported new devices into MIMO')
  end
end
