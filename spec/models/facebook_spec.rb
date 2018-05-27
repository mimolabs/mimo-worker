require 'rails_helper'

RSpec.describe Facebook, type: :model do
  describe 'retrieve a profile' do
    it 'should fetch a profile from facebook' do

      body = {"id"=>"my-id", "name"=>"Jenny The Cat", "email"=>"jenny@me.com", "link"=>"https://www.facebook.com/app_scoped_user_id/xxx/", "first_name"=>"Jenny", "last_name"=>"Cat", "gender"=>"mixed"}

      stub_request(:get, "https://graph.facebook.com/me/?access_token=MY-SECRET-TOKEN&fields=id,name,email,link,first_name,last_name,gender").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Faraday v0.15.1'
          }).
          to_return(status: 200, body: body.to_json, headers: {})

      opts = {
        'accessToken' => 'MY-SECRET-TOKEN'
      }
      details = Facebook.fetch(opts)
      expect(details['id']).to eq 'my-id'
      expect(details['name']).to eq 'Jenny The Cat'
    end
  end
end
