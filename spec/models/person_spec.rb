require 'rails_helper'

RSpec.describe Person, type: :model do

  let(:mac) { (1..6).map{"%0.2X"%rand(256)}.join('-') }
  let(:ap_mac) { (1..6).map{"%0.2X"%rand(256)}.join('-') }
  let(:mailer) { double('mailer') }
  let(:email_obj) { double('email_obj') }

  describe 'create demo data in' do

    before(:each) do
      Person.destroy_all
      Email.destroy_all
      Social.destroy_all
    end

    it 'should create the demo people' do
      Person.create_new_demo_people
      expect(Person.all.size).to be > 1
      expect(Location.find(10000)).to be_present

      person = Person.first
      expect(person.location_id).to eq 10000
      expect(person.login_count).to eq 1
      expect(person.created_at).to be_present
      expect(person.last_seen).to be_present
      # expect(person.first_name).to eq 'Demo'
      # expect(person.last_name).to eq 'User'

      station = Station.find_by person_id: person.id
      expect(station.location_id).to eq 10000
      expect(station.client_mac).to be_present
      expect(station.person_id).to eq person.id
    end

    it 'should create an email' do
      p = Person.new id: 123
      p.create_email

      e = Email.last
      expect(e.person_id).to eq 123
      expect(e.location_id).to eq 10000
    end

    it 'should create a social' do
      p = Person.new id: 123
      p.create_social

      s = Social.last
      expect(s.location_id).to eq 10_000
    end

    it 'should create an sms' do
      p = Person.new id: 123
      p.create_sms

      s = Sms.last
      expect(s.location_id).to eq 10_000
      expect(s.number).to be_present
      expect(s.person_id).to eq 123
    end
  end

  describe 'updating demo data' do

    it 'should update some people' do

    end

  end

  describe 'deleting the old dd' do
    it 'should wipe out older data - including dependent destroy' do
      person = Person.create location_id: 10_000, last_seen: Time.now - 100.days
      Person.create location_id: 10_000, last_seen: Time.now - 10.days
      Person.create location_id: 10

      Email.create location_id: 10_000, person_id: person.id
      Social.create location_id: 10_000, person_id: person.id
      Sms.create location_id: 10_000, person_id: person.id

      Person.delete_old_demo_data

      expect(Person.all.size).to eq 2
      expect(Email.all.size).to eq 0
      expect(Social.all.size).to eq 0
      expect(Sms.all.size).to eq 0
    end
  end

  describe '#destroy_relations' do
    it 'should destroy all the relations - no notify' do
      location_id = 123
      person = Person.create location_id: location_id
      Email.create location_id: location_id, person_id: person.id, email: Faker::Internet.email
      Social.create location_id: location_id, location_ids: [location_id], person_id: person.id
      Sms.create location_id: location_id, person_id: person.id
      PersonTimeline.create location_id: location_id, person_id: person.id
      expect(Email.all.size).to eq 1
      expect(Social.all.size).to eq 1
      expect(Sms.all.size).to eq 1
      expect(PersonTimeline.all.size).to eq 1
      opts = {
        'location_id' => location_id,
        'person_id' => person.id
      }
      expect {Person.destroy_relations(opts)}.to change { ActionMailer::Base.deliveries.count }.by(0)
      expect(Email.all.size).to eq 0
      expect(Social.all.size).to eq 0
      expect(Sms.all.size).to eq 0
      expect(PersonTimeline.all.size).to eq 0
    end

    it 'should notify location owner if end user request' do
      user = User.create email: Faker::Internet.email
      location = Location.create user_id: user.id, location_name: Faker::Name.first_name
      person = Person.create location_id: location.id
      opts = {
        'portal_request' => true,
        'location_id' => location.id,
        'person_id' => person.id
      }
      expect { Person.destroy_relations({'portal_request' => true, 'location_id' => location.id, 'person_id' => person.id}) }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(Person.instance_variable_get(:@mailer_opts)).to eq({email: user.email, location_name: location.location_name})
    end
  end

  describe '#create_portal_links_email' do
    it 'creates a body of ids + codes and saves them all to redis' do
      ids = [123, 456, 789]
      Person.create_access_codes(ids)
      expect(Person.instance_variable_get(:@mailer_data).size).to eq 3
      expect(Person.instance_variable_get(:@mailer_data)[0][:id]).to eq 123
      expect(Person.instance_variable_get(:@mailer_data)[1][:id]).to eq 456
      expect(Person.instance_variable_get(:@mailer_data)[2][:id]).to eq 789

      expect(REDIS.get("timelinePortalCode:#{123}")).not_to eq nil
      expect(REDIS.get("timelinePortalCode:#{456}")).not_to eq nil
      expect(REDIS.get("timelinePortalCode:#{789}")).not_to eq nil
    end

    it 'finds all people associated with an email address' do
      email_address = Faker::Internet.email
      person_one = Person.create email: email_address
      person_two = Person.create
      person_three = Person.create
      person_two_email = Email.create email: email_address, person_id: person_two.id
      person_three_social = Social.create email: email_address, person_id: person_three.id
      expect(Person.get_people_ids(email_address)).to include person_one.id
      expect(Person.get_people_ids(email_address)).to include person_two.id
      expect(Person.get_people_ids(email_address)).to include person_three.id
    end

    it 'should send off all the right data if there\'s a person associated' do
      person = Person.create email: Faker::Internet.email
      expect {Person.create_portal_links_email(person.email)}.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(Person.instance_variable_get(:@mailer_data).size).to eq 1
      expect(Person.instance_variable_get(:@mailer_data)[0][:id]).to eq person.id
      expect(Person.instance_variable_get(:@mailer_opts)[:email]).to eq person.email
    end
  end
end
