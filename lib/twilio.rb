##
## The Twilio module provides a way to interact with the Twilio API. Mostly used for OTP requests.
#
# It requires the twilio env vars are set. See docs for further information.

module Twilio

  ##
  # Sends the One Time Password (OTP) to a user and logs the request in an EventLog

  def self.send_otp(opts)
    splash = SplashPage.find_by id: opts['splash_id']
    return false unless splash.present? && splash.twilio_from

    opts['from'] = splash.twilio_from

    body = I18n.t(:"splash.otp_code", :default => "Your one-time password is:")
    puts body

    body = (body + " #{opts['code']}")

    url = "https://api.twilio.com/2010-04-01/Accounts/#{ENV['TWILLIO_USER']}/Messages.json"
    body = {
      "To" => opts['to'],
      "From" => opts['from'],
      "Body" => body
    }

    conn = Faraday.new(:url => "#{url}") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    conn.basic_auth(splash.twilio_user, splash.twilio_pass)
    response = conn.post do |req|
      req.body = body
    end

    log_otp(response,opts)
    return true
  rescue => e
    ### Should log
    puts e
    false
  end

  ## Logs the request from Twilio as an event log

  def self.log_otp(response, opts)
    e = EventLog.new
    e.location_id = opts['location_id']
    e.event_type = 'otp'
    e.response = response.body
    e.data = opts.to_json
    e.save
  end
end
