require 'rails_helper'

RSpec.describe Google, type: :model do
  describe 'retrieve a profile' do
    it 'should fetch a profile from google' do
      opts = {
        :token => 'MY-SECRET-TOKEN'
      }

      body = {"kind"=>"plus#person", "gender"=>"male", "objectType"=>"person", "id"=>"xxx", "displayName"=>"Simon Morley", "name"=>{"familyName"=>"Morley", "givenName"=>"Simon"}, "url"=>"https://plus.google.com/+SimonMorleyPS", "image"=>{"url"=>"https://lh3.googleusercontent.com/-tsh7P_FCm0s/AAAAAAAAAAI/AAAAAAAAAn8/zO5aofMYpYU/photo.jpg?sz=50", "isDefault"=>false}, "organizations"=>[{"name"=>"King's College London", "title"=>"Mechanical Engineering", "type"=>"school", "endDate"=>"2003", "primary"=>false}, {"name"=>"PolkaSpots Supafly Wi-Fi", "title"=>"CEO", "type"=>"work", "primary"=>true}], "placesLived"=>[{"value"=>"London", "primary"=>true}], "isPlusUser"=>true, "circledByCount"=>69, "verified"=>false}

     stub_request(:get, "https://www.googleapis.com/plus/v1/people/me").
       with(
         headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'Bearer MY-SECRET-TOKEN',
        'User-Agent'=>'Faraday v0.15.1'
         }).
         to_return(status: 200, body: body.to_json, headers: {})

      name = {"familyName"=>"Morley", "givenName"=>"Simon"}
      details = Google.fetch(opts)
      expect(details['id']).to eq 'xxx'
      expect(details['name']).to eq name
      expect(details['type']).to eq 'google'
    end
  end
end
