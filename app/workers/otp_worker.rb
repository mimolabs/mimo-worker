class OtpWorker

  include Sidekiq::Worker

  def perform(opts)
    Twilio.send_otp(opts)
  end
end
