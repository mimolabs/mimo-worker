require 'rails_helper'

RSpec.describe Email, type: :model do
  describe 'sending OTP' do

    before(:each) do 
      REDIS.flushall
    end

    fit "should subscribe the email to mailchimp" do
      email = Email.new
      splash = SplashPage.new newsletter_api_token: 123

      expect(email.add_to_list(splash.id)).to eq false

      splash.update(
        newsletter_active: true,
        newsletter_api_token: 'xxx-us7',
        newsletter_list_id: 'my-list',
        newsletter_type: 2,
      )

      stub_request(:post, "https://us7.api.mailchimp.com/3.0/lists/my-list/members").
        with(
          body: "{\"email_address\":null,\"status\":\"pending\"}",
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'apikey xxx',
            'Content-Type'=>'application/json',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 200, body: "", headers: {})

      expect(email.add_to_list(splash.id)).to eq true
    end

    it "should subscribe the email to cm" do
      email = Email.new
      splash = SplashPage.new newsletter_api_token: 123

      expect(email.add_to_list(splash.id)).to eq false

      splash.update(
        newsletter_active: true,
        newsletter_api_token: 'xxx-us7',
        newsletter_list_id: 'my-list',
        newsletter_type: 3,
      )

      expect(email.add_to_list(splash.id)).to eq true
    end
  end
end
