require 'rails_helper'

RSpec.describe Social, type: :model do

  let(:mac) { (1..6).map{"%0.2X"%rand(256)}.join('-') }

  describe 'fetching and saving socials' do

    before(:each) do
      Person.destroy_all
      Social.destroy_all
      Station.destroy_all
    end

    describe "processing socials and creating records" do
      it 'should create a facebooker' do
        body = {"id"=>"my-id", "name"=>"Jenny The Cat", "email"=>"jenny@me.com", "link"=>"https://www.facebook.com/app_scoped_user_id/xxx/", "first_name"=>"Jenny", "last_name"=>"Cat", "gender"=>"mixed"}
        
        stub_request(:get, "https://graph.facebook.com/me/?access_token=secret&fields=id,name,email,link,first_name,last_name,gender").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v0.15.1'
           }).
         to_return(status: 200, body: body.to_json, headers: {})


        body = { social_type: 'fb', token: 'secret' } 
        body[:location_id]   = 123
        body[:person_id]     = 1

        s = Social.fetch(body)
        expect(s).to eq true

        s = Social.last
        expect(s.location_id).to eq 123
        expect(s.person_id).to eq 1
        expect(s.email).to eq 'jenny@me.com'
      end
    end

    describe 'Facebook' do
      it 'should fetch the social details from facebook' do
        Social.new location_id: 100

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

        auth = Social.fetch_facebook(opts)
        expect(auth['id']).to eq 'my-id'
        expect(auth['location_id']).to eq 100
        expect(auth['client_mac']).to eq 'mac'
        expect(auth['newsletter']).to eq true
        expect(auth['person_id']).to eq 12345
      end

      it 'should create a social from the facebook auth details' do
        body = {"id"=>"my-id", "name"=>"Jenny The Cat", "email"=>"jenny@me.com", "link"=>"https://www.facebook.com/app_scoped_user_id/xxx/", "first_name"=>"Jenny", "last_name"=>"Cat", "gender"=>"mixed"}

        client_mac = mac
        p = Person.create client_mac: client_mac

        body['location_id']   = 123
        body['client_mac']    = client_mac
        body['person_id']     = p.id
        body['type']          = 'facebook'

        s = Social.create_social(body)
        expect(s).to eq true

        s = Social.last
        expect(s.location_id).to eq 123
        expect(s.person_id).to eq 1
        expect(s.email).to eq 'jenny@me.com'
        expect(s.facebook_id).to eq 'my-id'
        expect(s.meta['facebook']['link']).to eq 'https://www.facebook.com/app_scoped_user_id/xxx/'

        expect(s.first_name).to eq 'Jenny'
        expect(s.last_name).to eq 'Cat'
      end

      ## Checks in via fb on one device
      ## Station and person are created
      ## Checks in again later on another device
      ## There should be one person, one social, two stations
      it 'should create a social and update the station with the correct person id' do
        body = {"id"=>"my-id", "name"=>"Jenny The Cat", "email"=>"jenny@me.com", "link"=>"https://www.facebook.com/app_scoped_user_id/xxx/", "first_name"=>"Jenny", "last_name"=>"Cat", "gender"=>"mixed"}

        client_mac = mac

        p = Person.create client_mac: client_mac
        Station.create client_mac: client_mac, person_id: p.id

        body['location_id']   = 123
        body['client_mac']    = client_mac
        body['person_id']     = p.id

        Social.create_social(body)
        s = Social.last
        expect(s.location_id).to eq 123
        expect(s.person_id).to eq p.id
        expect(s.email).to eq 'jenny@me.com'

        client_mac_next = client_mac

        p2 = Person.create! client_mac: client_mac_next
        st = Station.create! client_mac: client_mac_next, person_id: p2.id
        expect(Person.all.size).to eq 2

        body['person_id'] = p2.id

        Social.create_social(body)
        expect(Social.all.size).to eq 1
        expect(Person.all.size).to eq 1
        expect(st.person_id).to eq p2.id
      end
    end

    describe 'Google' do
      it 'should save google auth deets to a social' do
        body = {"kind"=>"plus#person", "gender"=>"male", "objectType"=>"person", "id"=>"xxx", "displayName"=>"Simon Morley", "name"=>{"familyName"=>"Morley", "givenName"=>"Simon"}, "url"=>"https://plus.google.com/+SimonMorleyPS", "image"=>{"url"=>"https://lh3.googleusercontent.com/-tsh7P_FCm0s/AAAAAAAAAAI/AAAAAAAAAn8/zO5aofMYpYU/photo.jpg?sz=50", "isDefault"=>false}, "organizations"=>[{"name"=>"King's College London", "title"=>"Mechanical Engineering", "type"=>"school", "endDate"=>"2003", "primary"=>false}, {"name"=>"PolkaSpots Supafly Wi-Fi", "title"=>"CEO", "type"=>"work", "primary"=>true}], "placesLived"=>[{"value"=>"London", "primary"=>true}], "isPlusUser"=>true, "circledByCount"=>69, "verified"=>false}

        client_mac = mac
        p = Person.create client_mac: client_mac

        body['location_id']   = 123
        body['client_mac']    = client_mac
        body['person_id']     = p.id
        body['type']          = 'google'

        Social.create_social(body)
        s = Social.last
        expect(s.location_id).to eq 123
        expect(s.person_id).to eq p.id
        expect(s.google_id).to eq 'xxx'
        expect(s.meta['google']['url']).to eq "https://plus.google.com/+SimonMorleyPS"
        
        expect(s.first_name).to eq 'Simon'
        expect(s.last_name).to eq 'Morley'
      end
    end

    describe 'Twitter' do
      it 'should save twitter auth deets to a social' do
        
        body = {"id"=>2244994945, "id_str"=>"2244994945", "name"=>"Twitter Dev", "screen_name"=>"TwitterDev", "location"=>"Internet", "profile_location"=>nil, "description"=>"Your official source for Twitter Platform news, updates & events. Need technical help? Visit https://t.co/mGHnxZU8c1 TapIntoTwitter", "url"=>"https://t.co/FGl7VOULyL"}

        client_mac = mac
        p = Person.create client_mac: client_mac

        body['location_id']   = 123
        body['client_mac']    = client_mac
        body['person_id']     = p.id
        body['type']          = 'twitter'

        Social.create_social(body)
        s = Social.last
        expect(s.location_id).to eq 123
        expect(s.person_id).to eq p.id
        expect(s.twitter_id).to eq '2244994945'
        expect(s.meta['twitter']['url']).to eq "https://t.co/FGl7VOULyL"
        expect(s.checkins).to eq 1

        ### Checkins should be incremented
        Social.create_social(body)
        expect(s.reload.checkins).to eq 2
      end
    end
  end

  describe 'general creation of socials' do

    it 'should update a person after saving' do

      body = {"id"=>"my-id", "name"=>"Jenny The Cat", "email"=>"jenny@me.com", "link"=>"https://www.facebook.com/app_scoped_user_id/xxx/", "first_name"=>"Jenny", "last_name"=>"Cat", "gender"=>"mixed"}

      client_mac = mac
      p = Person.create client_mac: client_mac

      body['location_id']   = 123
      body['client_mac']    = client_mac
      body['person_id']     = p.id
      body['type']          = 'facebook'

      Social.create_social(body)

      expect(p.reload.email).to eq 'jenny@me.com'
      expect(p.first_name).to eq 'Jenny'
      expect(p.last_name).to eq 'Cat'
      expect(p.facebook).to eq true
    end

  end
end
