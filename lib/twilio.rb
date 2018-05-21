module Twilio

  def self.send_otp(opts)
    splash = SplashPage.find_by id: opts['splash_id']
    return false unless splash.present? && splash.twilio_from

    opts['from'] = splash.twilio_from

    body = I18n.t(:"splash.otp_code", :default => "Your one-time password is:")
    body = body + " " + opts['code']

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
    conn.basic_auth(ENV['TWILLIO_USER'], ENV['TWILLIO_PASS'])
    response = conn.post do |req|
      req.body = body
    end

    # log_otp(response,opts)
    return true
  rescue
    puts response.inspect
  end
end
