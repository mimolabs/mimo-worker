require 'rails_helper'

RSpec.describe PeopleRelation, type: :model do

  let(:mac) { (1..6).map{"%0.2X"%rand(256)}.join('-') }
  let(:ap_mac) { (1..6).map{"%0.2X"%rand(256)}.join('-') }

  describe 'create people relations - after logging in' do

    before(:each) do
      Person.destroy_all
      Station.destroy_all
      Sms.destroy_all
    end

    fit 'should create a station for a login' do
      client_mac = mac
      t = (Time.now - 10.days).to_i
      s = SplashPage.create location_id: 100
      sms = Sms.create(location_id: 1000, client_mac: client_mac, number: '1234')
      email = 'simon.morley@egg.com'
    
      opts = {}
      opts['client_mac'] = client_mac
      opts['splash_id'] = s.id
      opts['timestamp'] = t
      opts['email'] = email
      opts['location_id'] = 1000
      opts['ap_mac'] = ap_mac
      opts['consent'] = { 'terms': true }
      opts['otp'] = 'true'

      expect(PeopleRelation.record(opts)).to eq true

      station = Station.last
      person = Person.last
      e = Email.last

      expect(station.client_mac).to eq client_mac
      expect(station.person_id).to eq person.id

      ls = person.last_seen
      expect(ls).to be_present
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

      ### Terms Timeline
      pt = PersonTimeline.where(event: 'agreement_terms').first
      expect(pt.person_id).to eq person.id
      expect(pt.location_id).to eq 1000
      expect(pt.created_at).to eq Time.at t
      expect(pt.meta['client_mac']).to eq client_mac

      ### Person Terms Timeline
      pt = PersonTimeline.where(event: 'sign_in_sms').first
      expect(pt.person_id).to eq person.id
      expect(pt.location_id).to eq 1000
      expect(pt.created_at).to eq Time.at t
      expect(pt.meta['client_mac']).to eq client_mac
      expect(pt.meta['email']).to eq email
      expect(pt.meta['sms']).to eq '1234'

      ### ensure we update the email
      person.update email: nil

      expect(PeopleRelation.record(opts)).to eq true
      expect(person.reload.login_count).to eq 2
      expect(person.last_seen).to be_present
      expect(person.last_seen).to_not eq ls
      expect(person.email).to eq email

      # otp
      expect(sms.reload.person_id).to eq person.id
    end

    fit 'should not create terms timeline - not consent' do
      t = (Time.now - 10.days).to_i
      s = SplashPage.create location_id: 100
      email = 'simon.morley@egg.com'
    
      opts = {}
      opts['client_mac'] = mac
      opts['location_id'] = 100
      opts['splash_id'] = s.id
      opts['timestamp'] = t
      opts['email'] = email
      opts['location_id'] = 1000
      opts['ap_mac'] = ap_mac
      opts['sms_number'] = '1234'

      expect(PeopleRelation.record(opts)).to eq true
      pt = PersonTimeline.where(event: 'agreement_terms').first
      expect(pt).to eq nil
    end

    fit 'should mark as consented - external email' do
      t = (Time.now - 10.days).to_i
      s = SplashPage.create location_id: 100
      email = 'simon.morley@egg.com'
    
      opts = {}
      opts['client_mac'] = mac
      opts['location_id'] = 100
      opts['splash_id'] = s.id
      opts['timestamp'] = t
      opts['email'] = email
      opts['location_id'] = 1000
      opts['ap_mac'] = ap_mac
      opts['external_capture'] = true

      expect(PeopleRelation.record(opts)).to eq true
      person = Person.last
      expect(person.consented).to eq true
    end

    fit 'should mark as consented - doi disabled' do
      t = (Time.now - 10.days).to_i
      s = SplashPage.create location_id: 100
      email = 'simon.morley@egg.com'
    
      opts = {}
      opts['client_mac'] = mac
      opts['location_id'] = 100
      opts['splash_id'] = s.id
      opts['timestamp'] = t
      opts['email'] = email
      opts['location_id'] = 1000
      opts['ap_mac'] = ap_mac
      opts['double_opt_in'] = false

      expect(PeopleRelation.record(opts)).to eq true
      person = Person.last
      expect(person.consented).to eq true
    end
  end


  it 'should mark as consented for external email capture' do
    ## include the email too
    ## include the person
  end

  it 'should create the SMS log for an OTP user'

end
