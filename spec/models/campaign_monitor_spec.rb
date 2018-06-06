require 'rails_helper'

RSpec.describe Email, type: :model do
  describe 'sending OTP' do

    before(:each) do 
      REDIS.flushall
      CreateSend::CreateSend.user_agent "eggs"
    end

    it "should run subscribe the email to campaign monitor" do
      splash = SplashPage.new id: 123

      opts = {}
      opts[:list] = 'my-list'
      opts[:token] = 'xxx-us7'
      opts[:splash_id] = splash.id

      my_email = Faker::Internet.email
      email = Email.new email: my_email
      
      stub_request(:post, "https://api.createsend.com/api/v3.1/subscribers/my-list.json").
        with(
          body: "{\"EmailAddress\":\"#{my_email}\",\"Name\":\"\",\"CustomFields\":[],\"Resubscribe\":true,\"RestartSubscriptionBasedAutoresponders\":false}",
          headers: {
            'Authorization'=>'Basic eHh4LXVzNzp4',
            'Content-Type'=>'application/json; charset=utf-8',
            'User-Agent'=>'eggs'
          }).
          to_return(status: 200, body: my_email, headers: {})

      expect(email.cm_subscribe(opts)).to eq true
      expect(email.reload.lists[0]).to eq 'my-list'

      tl = PersonTimeline.last
      expect(tl[:meta]['list']).to eq 'my-list'
      expect(tl[:meta]['email']).to eq my_email

      ### cannot sub to list twice
      expect(email.mc_subscribe(opts)).to eq false

      ### failure - mc
    end

    it "should not send - list disabled cos of an error" do
      splash = SplashPage.new id: 123

      opts = {}
      opts[:list] = 'my-list'
      opts[:token] = 'xxx-us7'
      opts[:splash_id] = splash.id

      my_email = Faker::Internet.email
      email = Email.new email: my_email

      key = email.cm_key(123)
      REDIS.set key, 1
      expect(email.cm_subscribe(opts)).to eq false
    end
  end
end
