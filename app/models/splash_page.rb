# frozen_string_literal: true

class SplashPage < ApplicationRecord

  belongs_to :location

  ##
  # Runs every morning at 6:58 am by the scheduler. It changes all the passwords and emails the
  # new version to the email that's been added to the splash.
  def self.send_daily_passwords
    splash_pages = with_passwd_auto_gen
    return unless splash_pages.present?
    splash_pages.map { |s| s.change_password_and_notify }
  end

  ##
  # Sends the daily password email to the designated email recipient
  def send_password
    opts = { 
      email: passwd_change_email,
      password: password,
      location_name: location.try(:location_name)
    }
    SplashMailer.with(opts).daily_password.deliver_now
  end

  ## 
  # Changes the password and sends an email to the splash.email
  def change_password_and_notify
    return unless passwd_change_day.include? Date.today.wday.to_s
    new_password = Helpers.words
    self.update password: new_password
    send_password
  end

  ##
  # Finds all the splash pages with password auto gen enabled. Used in the send_daily_passwords function.
  def self.with_passwd_auto_gen
    SplashPage.where(passwd_auto_gen: true, backup_password: true, active: true)
              .where.not(passwd_change_day: [nil, ''], passwd_change_email: [nil,''])
  end
end
