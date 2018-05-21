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

    fit "should subscribe the email to cm" do
      email = Email.new
      splash = SplashPage.new newsletter_api_token: 123

      expect(email.add_to_list(splash.id)).to eq false

      splash.update(
        newsletter_active: true,
        newsletter_api_token: 'xxx-us7',
        newsletter_list_id: 'my-list',
        newsletter_type: 3,
      )
      stub_request(:post, "https://api.createsend.com/api/v3.1/subscribers/my-list.json").
        with(
          body: "{\"EmailAddress\":null,\"Name\":\"\",\"CustomFields\":[],\"Resubscribe\":true,\"RestartSubscriptionBasedAutoresponders\":false}",
          headers: {
            'Authorization'=>'Basic eHh4LXVzNzp4',
            'Content-Type'=>'application/json; charset=utf-8',
            'User-Agent'=>'createsend-ruby-4.1.2-2.5.1-p57-x86_64-darwin17'
          }).
          to_return(status: 200, body: "", headers: {})
      expect(email.add_to_list(splash.id)).to eq true
    end

    fit "should subscribe the email to sg" do
      my_email = Faker::Internet.email
      email = Email.new email: my_email
      splash = SplashPage.new newsletter_api_token: 123

      expect(email.add_to_list(splash.id)).to eq false

      splash.update(
        newsletter_active: true,
        newsletter_api_token: 'xxx-us7',
        newsletter_list_id: 'my-list',
        newsletter_type: 4,
      )

      rid = SecureRandom.hex
      body = { persisted_recipients: [ rid ] }.to_json

      stub_request(:post, "https://api.sendgrid.com/v3/contactdb/recipients").
        with(
          body: "[{\"email\":\"#{my_email}\"}]",
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'Bearer xxx-us7',
            'Content-Type'=>'application/json',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 201, body: body, headers: {})

          stub_request(:post, "https://api.sendgrid.com/v3/contactdb/lists/my-list/recipients/#{rid}").
            with(
              headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Authorization'=>'Bearer xxx-us7',
                'Content-Length'=>'0',
                'Content-Type'=>'application/json',
                'User-Agent'=>'Faraday v0.15.1'
              }).
              to_return(status: 201, body: "", headers: {})

      expect(email.add_to_list(splash.id)).to eq true
    end
  end
end
