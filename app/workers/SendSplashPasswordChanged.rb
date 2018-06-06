# frozen_string_literal: true

class SendSplashPasswordChanged
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def perform(args={})
    Splash.send_daily_passwords
  end
end
