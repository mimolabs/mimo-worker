require 'rails_helper'

RSpec.describe Email, type: :model do
  describe 'sending OTP' do

    before(:each) do 
      REDIS.flushall
    end

    it "should run subscribe the email to campaign monitor" do
      splash = SplashPage.new id: 123

      opts = {}
      opts[:list] = 'my-list'
      opts[:token] = 'xxx-us7'
      opts[:splash_id] = splash.id

      my_email = Faker::Internet.email
      email = Email.new email: my_email
      
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

      expect(email.sg_subscribe(opts)).to eq true
      expect(email.reload.lists[0]).to eq 'my-list'

      tl = PersonTimeline.last
      expect(tl[:meta]['list']).to eq 'my-list'
      expect(tl[:meta]['email']).to eq my_email

      ### cannot sub to list twice
      expect(email.sg_subscribe(opts)).to eq false
    end

    ### Fails due to call issue to create recipient
    it "should fail to subscribe the email to campaign monitor" do
      splash = SplashPage.new id: 123

      opts = {}
      opts[:list] = 'my-list'
      opts[:token] = 'xxx-us7'
      opts[:splash_id] = splash.id

      my_email = Faker::Internet.email
      email = Email.new email: my_email
      
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
          to_return(status: 401, body: body, headers: {})

      expect(email.sg_subscribe(opts)).to eq false
      key = email.sg_key(123)

      val = REDIS.get key
      expect(val).to eq 'Invalid API token'
    end

    it "should not send - list disabled cos of an error" do
      splash = SplashPage.new id: 123

      opts = {}
      opts[:list] = 'my-list'
      opts[:token] = 'xxx-us7'
      opts[:splash_id] = splash.id

      my_email = Faker::Internet.email
      email = Email.new email: my_email

      key = email.sg_key(123)
      REDIS.set key, 1
      expect(email.sg_subscribe(opts)).to eq false
    end
  end
end
