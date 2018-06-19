# frozen_string_literal: true

class SendSplashPasswordChanged
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def perform(args={})
    SplashPage.send_daily_passwords
  end
end
