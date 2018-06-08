require 'rails_helper'

RSpec.describe Person, type: :model do

  let(:mac) { (1..6).map{"%0.2X"%rand(256)}.join('-') }
  let(:ap_mac) { (1..6).map{"%0.2X"%rand(256)}.join('-') }

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

  describe 'destroy_relations' do
    it 'should destroy all the relations' do
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
      Person.destroy_relations({'location_id' => location_id, 'person_id' => person.id})
      expect(Email.all.size).to eq 0
      expect(Social.all.size).to eq 0
      expect(Sms.all.size).to eq 0
      expect(PersonTimeline.all.size).to eq 0
    end
  end
end
