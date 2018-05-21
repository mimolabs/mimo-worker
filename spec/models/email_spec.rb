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
          body: "{\"email_address\":null,\"status\":null}",
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

    fit "should run subscribe the email to mailchimp" do
      splash = SplashPage.new id: 123

      opts = {}
      opts[:list] = 'my-list'
      opts[:token] = 'xxx-us7'
      opts[:splash_id] = splash.id

      my_email = Faker::Internet.email
      email = Email.new email: my_email
      
     stub_request(:post, "https://us7.api.mailchimp.com/3.0/lists/my-list/members").
       with(
         body: "{\"email_address\":null,\"status\":null}",
         headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'apikey xxx',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Faraday v0.15.1'
         }).
       to_return(status: 200, body: "", headers: {})

      expect(email.mc_subscribe(opts)).to eq true
      expect(email.reload.lists[0]).to eq 'my-list'

      tl = PersonTimeline.last
      expect(tl[:meta]['list']).to eq 'my-list'
      expect(tl[:meta]['email']).to eq my_email

      ### cannot sub to list twice
      expect(email.mc_subscribe(opts)).to eq false

      ### failure - mc
      email.lists = []
    
      body = {detail: 'eggs'}.to_json
      stub_request(:post, "https://us7.api.mailchimp.com/3.0/lists/my-list/members").
       with(
         body: "{\"email_address\":null,\"status\":null}",
         headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'apikey xxx',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Faraday v0.15.1'
         }).
       to_return(status: 401, body: body, headers: {})

       ### 401 = unauthed
       expect(email.mc_subscribe(opts)).to eq false
       key = email.mc_key(123)
       val = REDIS.get key
       expect(val).to eq 'eggs'
    end

    fit "should not send - list disabled cos of an error" do
      splash = SplashPage.new id: 123

      opts = {}
      opts[:list] = 'my-list'
      opts[:token] = 'xxx-us7'
      opts[:splash_id] = splash.id

      my_email = Faker::Internet.email
      email = Email.new email: my_email

      key = email.mc_key(123)
      REDIS.set key, 1
      expect(email.mc_subscribe(opts)).to eq false
    end

    fit "should not send - invalid URL" do
      splash = SplashPage.new id: 123

      opts = {}
      opts[:list] = 'my-list'
      opts[:token] = 'us7'
      opts[:splash_id] = splash.id

      my_email = Faker::Internet.email
      email = Email.new email: my_email

      expect(email.mc_subscribe(opts)).to eq false

      key = email.mc_key(123)
      val = REDIS.get key
      expect(val).to eq 'Invalid API token'
    end

    it 'it should format the token for MC' do
      e = Email.new
      token = 'xxx-us7'

      a = e.mc_url_token(token)
      expect(a[0]).to eq 'https://us7.api.mailchimp.com/3.0'
      expect(a[1]).to eq 'xxx'
    end
  end
end
