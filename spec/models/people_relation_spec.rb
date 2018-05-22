require 'rails_helper'

RSpec.describe PeopleRelation, type: :model do

  let(:client_mac) { (1..6).map{"%0.2X"%rand(256)}.join('-') }
  let(:ap_mac) { (1..6).map{"%0.2X"%rand(256)}.join('-') }

  describe 'create people relations - after logging in' do

    before(:each) do
      Person.destroy_all
      Station.destroy_all
    end

    it 'should create a station for a login' do
      t = (Time.now - 10.days).to_i
      s = SplashPage.create location_id: 100
      email = 'simon.morley@egg.com'

      opts = {}
      opts['client_mac'] = client_mac
      opts['location_id'] = 100
      opts['splash_id'] = s.id
      opts['timestamp'] = t
      opts['email'] = email
      opts['location_id'] = 1000
      opts['ap_mac'] = ap_mac

      expect(PeopleRelation.record(opts)).to eq true

      station = Station.last
      person = Person.last
      e = Email.last

      expect(station.client_mac).to eq client_mac
      expect(station.person_id).to eq person.id

      expect(person.email).to eq email
      expect(person.consented).to eq false
      expect(person.username).to eq 'Simon Morley'
      expect(person.first_name).to eq 'Simon'
      expect(person.last_name).to eq 'Morley'
      expect(person.login_count).to eq 1
      expect(person.location_id).to eq 1000

      expect(e.location_id).to eq 1000
      expect(e.email).to eq email
      expect(e.consented).to eq false
      expect(e.person_id).to eq person.id

      # terms timeline
      # sign in timeline 
    end
  end

  it 'should mark as consented for external email capture' do
    ## include the email too
    ## include the person
  end

  it 'should create the SMS log for an OTP user'

end
