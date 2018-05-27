require 'rails_helper'

RSpec.describe Social, type: :model do

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
        person_id: 12345
      }

      auth = s.fetch_facebook(opts)
      expect(auth['id']).to eq 'my-id'
      expect(auth['location_id']).to eq 100
      expect(auth['client_mac']).to eq 'mac'
      expect(auth['newsletter']).to eq true
      expect(auth['person_id']).to eq 12345
    end

  end

  describe 'general creation of socials' do



  end

end
