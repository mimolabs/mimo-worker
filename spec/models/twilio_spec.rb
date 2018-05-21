require 'rails_helper'

RSpec.describe Twilio, type: :model do
  describe 'sending OTP' do
    it 'should send the OTP to a user' do
      opts = {}
      expect(Twilio.send_otp(opts)).to eq false

      s = SplashPage.create 
      opts = { 'number': '+4477777777777777', code: 'xxxxx', 'splash_id' => s.id }

      expect(Twilio.send_otp(opts)).to eq false

      stub_request(:post, "https://api.twilio.com/2010-04-01/Accounts//Messages.json").
        with(
          body: {"Body"=>"Your one-time password is: . This is valid for 5 mins.", "From"=>"+44mynumberhere", "To"=>nil},
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'Basic Og==',
            'Content-Type'=>'application/x-www-form-urlencoded',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 200, body: "", headers: {})

      s.update twilio_user: 'simon', twilio_pass: 'morley', twilio_from: '+44mynumberhere'
      expect(Twilio.send_otp(opts)).to eq true
    end
  end
end
