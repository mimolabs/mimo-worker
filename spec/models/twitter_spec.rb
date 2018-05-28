require 'rails_helper'

RSpec.describe Twitter, type: :model do
  describe 'retrieve a profile' do
    it 'should fetch a profile from twitter' do
      opts = {
        :token => 'MY-SECRET-TOKEN'
      }

      details = Twitter.fetch(opts)
      expect(details).to be {}

      ENV['TWITTER_CONSUMER_KEY'] = "123"
      ENV['TWITTER_CONSUMER_SECRET'] = "456"

      body = { access_token: 'top-secret' }
      stub_request(:post, "https://api.twitter.com/oauth2/token").
        with(
          body: {"grant_type"=>"client_credentials"},
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'Basic MTIzOjQ1Ng==',
            'Content-Type'=>'application/x-www-form-urlencoded',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 200, body: body.to_json, headers: {})

      body = {"id"=>2244994945, "id_str"=>"2244994945", "name"=>"Twitter Dev", "screen_name"=>"TwitterDev", "location"=>"Internet", "profile_location"=>nil, "description"=>"Your official source for Twitter Platform news, updates & events. Need technical help? Visit https://t.co/mGHnxZU8c1 ⌨️ #TapIntoTwitter", "url"=>"https://t.co/FGl7VOULyL"}

      stub_request(:get, "https://api.twitter.com/1.1/users/show.json?screen_name=").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'Bearer top-secret',
            'Content-Type'=>'application/json',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 200, body: body.to_json, headers: {})

      details = Twitter.fetch(opts)
      expect(details['id']).to eq 2244994945
      expect(details['name']).to eq "Twitter Dev"
      expect(details['type']).to eq 'twitter'
    end
  end
end
