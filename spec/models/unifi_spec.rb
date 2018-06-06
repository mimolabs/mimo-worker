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

    before(:each) do 
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
      Box.destroy_all
    end


    it 'should fetch the devices from the unifi controller' do
      s = SplashIntegration.new username: @username, password: @password, host: @hostname
      s.save

      stub_request(:get, "https://1.2.3.4:8443/api/s/default/stat/device").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type'=>'application/json',
            'Cookie'=>'csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly',
            'Csrf-Token'=>'oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 200, body: device_body.to_json, headers: {})

      c = s.unifi_fetch_boxes
      expect(c[0]['_id']).to eq '5ae8545ae4b0b907c5218872'

    end

    it 'should fetch and import the boxes' do
      s = SplashIntegration.create username: @username, password: @password, host: @hostname, location_id: 123

      stub_request(:get, "https://1.2.3.4:8443/api/s/default/stat/device").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type'=>'application/json',
            'Cookie'=>'csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly',
            'Csrf-Token'=>'oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 200, body: device_body.to_json, headers: {})

      s.import_unifi_boxes
      b = Box.last
      expect(b.mac_address).to eq 'FF-FF-FF-FF-FF-FF'
    end

  end

  def device_body
    { 'data' => [{"_id"=>"5ae8545ae4b0b907c5218872", "adopted"=>true, "antenna_table"=>[{"id"=>4, "name"=>"Combined", "wifi0_gain"=>3}], "cfgversion"=>"377f690f355d2be0", "config_network"=>{"ip"=>"10.22.0.29", "type"=>"dhcp"}, "countrycode_table"=>[], "device_id"=>"5ae8545ae4b0b907c5218872", "ethernet_table"=>[{"mac"=>"ff:ff:ff:ff:ff:ff:ff", "name"=>"eth0", "num_port"=>1}], "fw_caps"=>194603, "guest-num_sta"=>0, "has_eth1"=>false, "has_speaker"=>false, "inform_ip"=>"1.2.3.4", "inform_url"=>"http://1.2.3.4:8080/inform", "ip"=>"10.22.0.29", "last_seen"=>1525362884, "license_state"=>"registered", "mac"=>"ff:ff:ff:ff:ff:ff", "model"=>"BZ2", "na-guest-num_sta"=>0, "na-num_sta"=>0, "na-user-num_sta"=>0, "ng-guest-num_sta"=>0, "ng-num_sta"=>0, "ng-user-num_sta"=>0, "num_sta"=>0, "port_table"=>[], "radio_na"=>nil, "radio_ng"=>{"builtin_ant_gain"=>3, "builtin_antenna"=>true, "current_antenna_gain"=>0, "max_txpower"=>23, "min_txpower"=>5, "name"=>"wifi0", "nss"=>2, "radio"=>"ng", "radio_caps"=>16404}, "radio_table"=>[{"builtin_ant_gain"=>3, "builtin_antenna"=>true, "current_antenna_gain"=>0, "max_txpower"=>23, "min_txpower"=>5, "name"=>"wifi0", "nss"=>2, "radio"=>"ng", "radio_caps"=>16404}], "scan_radio_table"=>[], "serial"=>"xxx", "site_id"=>"5a5f290be4b0b907c5218857", "state"=>0, "type"=>"uap", "uplink_table"=>[], "user-num_sta"=>0, "version"=>"3.9.27.8537", "vwireEnabled"=>true, "vwire_table"=>[], "wifi_caps"=>15989, "wlangroup_id_ng"=>"5a5f290de4b0b907c5218862", "x_authkey"=>"2ec4c1c8e2fc141b849368125d1f1606", "x_fingerprint"=>"", "x_has_ssh_hostkey"=>false, "x_vwirekey"=>""}] }
  end
end
