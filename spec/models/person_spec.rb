require 'rails_helper'
require 'zip'

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
      codes = Person.create_access_codes(ids)

      expect(codes.size).to eq ids.size
      expect(codes[0][:id]).to eq ids[0]
      expect(REDIS.get("timelinePortalCode:#{ids[0]}")).not_to eq nil
      expect(codes[1][:id]).to eq ids[1]
      expect(REDIS.get("timelinePortalCode:#{ids[1]}")).not_to eq nil
      expect(codes[2][:id]).to eq ids[2]
      expect(REDIS.get("timelinePortalCode:#{ids[2]}")).not_to eq nil
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
      expect(Person.instance_variable_get(:@mailer_opts)[:email]).to eq person.email
      expect(Person.instance_variable_get(:@mailer_opts)[:metadata][0][:id]).to eq person.id
    end

    it 'returns a timeline code + saves to redis' do
      short_week = 5
      id = 123
      data = Person.set_timeline_portal_code(short_week, id)
      expect(data[:id]).to eq id
      expect(data[:code]).to be_present
      expect(REDIS.get("timelinePortalCode:#{id}")).to eq data[:code]
    end
  end

  describe '#download_request' do
    it 'creates the zip for an email + sends, but deletes the zip' do
      person = Person.create email: Faker::Internet.email
      expect {Person.download_person_data({'person_id' => person.id, 'email' => person.email})}.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(File.exist?("/tmp/person_#{person.id}.zip")).to eq false
    end

    it 'creates a file for the person data' do
      first = Faker::Name.first_name
      last = Faker::Name.last_name
      person = Person.create first_name: first, last_name: last,
                             email: "#{first.downcase}_#{last.downcase}@email.com",
                             location_id: 123
      file_name = Person.person_csv(person)
      expect(File.file?("/tmp/#{file_name}")).to eq true
      csv = CSV.read("/tmp/#{file_name}", 'r')
      expect(csv[0][0]).to eq 'ID'
      expect(csv[1][0]).to eq person.id.to_s
      expect(csv[0][6]).to eq 'Email'
      expect(csv[1][6]).to eq person.email
      expect(csv[0].size).to eq csv[1].size
      File.delete("/tmp/#{file_name}") if File.exist?("/tmp/#{file_name}")
    end

    it 'creates a file for the email data' do
      person = Person.create
      email = Email.create email: Faker::Internet.email, person_id: person.id
      second_email = Email.create email: Faker::Internet.email, person_id: person.id
      file_name = Person.emails_csv('person_id' => person.id)
      expect(File.file?("/tmp/#{file_name}")).to eq true
      csv = CSV.read("/tmp/#{file_name}", 'r')
      expect(csv[0][0]).to eq 'ID'
      expect(csv[1][0]).to eq email.id.to_s
      expect(csv[2][0]).to eq second_email.id.to_s
      expect(csv[0][1]).to eq 'Email'
      expect(csv[1][1]).to eq email.email
      expect(csv[2][1]).to eq second_email.email
      expect(csv[0].size).to eq csv[1].size
      File.delete("/tmp/#{file_name}") if File.exist?("/tmp/#{file_name}")
    end

    it 'creates a file for the social data' do
      person = Person.create
      social = Social.create person_id: person.id, first_name: Faker::Name.first_name
      second_social = Social.create person_id: person.id, first_name: Faker::Name.first_name
      file_name = Person.social_csv('person_id' => person.id)
      expect(File.file?("/tmp/#{file_name}")).to eq true
      csv = CSV.read("/tmp/#{file_name}", 'r')
      expect(csv[0][0]).to eq 'ID'
      expect(csv[1][0]).to eq social.id.to_s
      expect(csv[2][0]).to eq second_social.id.to_s
      expect(csv[0][1]).to eq 'First_Name'
      expect(csv[1][1]).to eq social.first_name
      expect(csv[2][1]).to eq second_social.first_name
      expect(csv[0].size).to eq csv[1].size
      File.delete("/tmp/#{file_name}") if File.exist?("/tmp/#{file_name}")
    end

    it 'creates a file for the sms data' do
      person = Person.create
      sms = Sms.create person_id: person.id, number: '+112727337373'
      second_sms = Sms.create person_id: person.id, number: '+112730007373'
      file_name = Person.sms_csv('person_id' => person.id)
      expect(File.file?("/tmp/#{file_name}")).to eq true
      csv = CSV.read("/tmp/#{file_name}", 'r')
      expect(csv[0][0]).to eq 'ID'
      expect(csv[1][0]).to eq sms.id.to_s
      expect(csv[2][0]).to eq second_sms.id.to_s
      expect(csv[0][2]).to eq 'Number'
      expect(csv[1][2]).to eq sms.number
      expect(csv[2][2]).to eq second_sms.number
      expect(csv[0].size).to eq csv[1].size
      File.delete("/tmp/#{file_name}") if File.exist?("/tmp/#{file_name}")
    end
  end
end
