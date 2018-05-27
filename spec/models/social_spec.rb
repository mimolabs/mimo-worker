require 'rails_helper'

RSpec.describe Social, type: :model do

  let(:mac) { (1..6).map{"%0.2X"%rand(256)}.join('-') }

  describe 'restful requests to fetch social details' do

    it 'should fetch a facebook profile' do

    end

    it 'should fetch the social details from facebook' do
      s = Social.new location_id: 100

      body = {"id"=>"my-id", "name"=>"Jenny The Cat", "email"=>"jenny@me.com", "link"=>"https://www.facebook.com/app_scoped_user_id/xxx/", "first_name"=>"Jenny", "last_name"=>"Cat", "gender"=>"mixed"}

      stub_request(:get, "https://graph.facebook.com/me/?access_token=123&fields=id,name,email,link,first_name,last_name,gender").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 200, body: body.to_json, headers: {})

      opts = {
        token: 123,
        client_mac: 'mac',
        newsletter: true,
        person_id: 12345,
        location_id: 100
      }

      auth = s.fetch_facebook(opts)
      expect(auth['id']).to eq 'my-id'
      expect(auth['location_id']).to eq 100
      expect(auth['client_mac']).to eq 'mac'
      expect(auth['newsletter']).to eq true
      expect(auth['person_id']).to eq 12345
    end

    it 'should create a social from the facebook auth details' do
      body = {"id"=>"my-id", "name"=>"Jenny The Cat", "email"=>"jenny@me.com", "link"=>"https://www.facebook.com/app_scoped_user_id/xxx/", "first_name"=>"Jenny", "last_name"=>"Cat", "gender"=>"mixed"}

      client_mac = mac

      body['location_id']   = 123
      body['client_mac']    = client_mac
      body['person_id']     = 1

      s = Social.create_facebook(body)
      expect(s).to eq true

      s = Social.last
      expect(s.location_id).to eq 123
      expect(s.email).to eq 'jenny@me.com'
      expect(s.meta['facebook']['link']).to eq 'https://www.facebook.com/app_scoped_user_id/xxx/'
    end

  end

  describe 'general creation of socials' do



  end

end
