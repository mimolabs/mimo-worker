require 'rails_helper'

RSpec.describe Unifi, type: :model do
  
  before(:all) do
    @username = ENV['UNIFI_USER'] || 'simon'
    @password = ENV['UNIFI_PASS'] || 'morley'
    @hostname = ENV['UNIFI_HOST'] || 'https://1.2.3.4:8443'
  end

  describe 'authorising unifi requests' do

    it 'should not get the unifi credentials' do
      s = SplashIntegration.new username: 'bob', password: 'marley', host: @hostname
      s.save
      stub_request(:post, "https://1.2.3.4:8443/api/login").
        with(
          body: "{\"username\":\"bob\",\"password\":\"marley\"}",
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type'=>'application/json',
            'User-Agent'=>'Get MIMO!'
          }).
          to_return(status: 401, body: "", headers: {})
      
      expect(s.unifi_get_credentials).to eq false
    end

    it 'should get the unifi credentials with valid credentials' do
      s = SplashIntegration.new username: @username, password: @password, host: @hostname
      s.save
          
      headers = { 'set-cookie': "csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly" }
      stub_request(:post, "https://1.2.3.4:8443/api/login").
        with(
          body: "{\"username\":\"simon\",\"password\":\"morley\"}",
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type'=>'application/json',
            'User-Agent'=>'Get MIMO!'
          }).
          to_return(status: 200, body: "", headers: headers)

      c = s.unifi_get_credentials
      expect(c["cookie"]).to eq 'e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU'
    end
  end

  describe 'importing unifi devices' do

    it 'should fetch the devices from the unifi controller' do
      s = SplashIntegration.new username: @username, password: @password, host: @hostname
      s.save

      c = s.unifi_fetch_boxes
      expect(c).to eq 123
    end

  end
end
