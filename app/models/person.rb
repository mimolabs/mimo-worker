class Person < ApplicationRecord

  has_many :emails, dependent: :destroy
  has_many :socials, dependent: :destroy
  has_many :sms, dependent: :destroy

  def self.destroy_relations(options)
    return unless options['location_id'].present? && options['person_id'].present?

    Email.where(location_id: options['location_id'], person_id: options['person_id']).destroy_all
    Social.where(location_id: options['location_id'], person_id: options['person_id']).destroy_all
    Sms.where(location_id: options['location_id'], person_id: options['person_id']).destroy_all
    PersonTimeline.where(location_id: options['location_id'], person_id: options['person_id']).destroy_all

    return unless options['portal_request'] && Rails.env.production?
    notify_deletion(options)
  end
  #
  # def self.notify_deletion(options)
  #   loc = Location.find_by(id: options['location_id'])
  #   notify_slack(options, loc)
  #
  #   return unless loc && loc.user_id
  #   user = User.find_by(id: loc.user_id)
  #   return unless user
  #
  #   mailer_opts = {
  #     to_email: user.try(:email),
  #     from_email: 'no-way@oh-mimo.com',
  #     from_name: 'MIMO',
  #     subject: '[USER DELETED]',
  #     body: person_delete_body(loc)
  #   }
  #   Mailer.send_v2(mailer_opts)
  # end

  # def self.create_timeline(email)
  #   people_ids = get_people_ids(email)
  #   return unless people_ids.present?
  #   mailer_data = []
  #   week = 60*60*24*7
  #   people_ids.each do |person_id|
  #     code = SecureRandom.hex
  #     $redis.setex("timelinePortalCode:#{person_id}", week, code)
  #     mailer_data << {id: person_id, code: code}
  #   end
  #   email_opts = compose_email(mailer_data, options)
  # end
  #
  # def self.get_people_ids(email)
  #   ids = []
  #   Person.where(email: email).each do |person|
  #     ids << person.id.to_s
  #   end
  #   Email.where(email: email, :person_id.exists => true).each do |e|
  #     ids << e.person_id if e.person_id.present?
  #   end
  #   Social.where(email: email, :person_id.exists => true).each do |s|
  #     ids << s.person_id if s.person_id.present?
  #   end
  #   ids.uniq
  # end

  def self.create_demo_data
    create_new_demo_people
    update_existing_demo_data
    delete_old_demo_data
  end

  def self.demo_location
    10_000
  end

  def create_station
    station = Station.create(
      location_id:  Person.demo_location,
      person_id:    id,
      client_mac:   client_mac
    )
    station
  end

  def self.create_person
    sign_in_time = Time.now - rand(60 * 60 * 24).seconds
    person = Person.create(
      location_id: Person.demo_location,
      login_count: 1,
      created_at: sign_in_time,
      last_seen: sign_in_time,
      first_name: 'Demo',
      last_name: 'User',
      client_mac: generate_mac
    )
    person
  end

  def create_email
    email = Faker::Internet.email
    Email.create person_id: id, location_id: Person.demo_location, email: email, consented: [true, false].sample
    email
  end

  def create_sms
    Sms.create(
      location_id: Person.demo_location,
      person_id: id, client_mac: client_mac,
      number: '+44 7' + (100_000_000 + rand(899999999)).to_s
    )
  end

  ### Think we need to refactor this for the new metadata approach towards storing customer data
  def create_social
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name

    social = Social.create(
      location_id: Person.demo_location,
      person_id: id,
      first_name: first_name,
      last_name: last_name,
      email: Faker::Internet.email
    )
    social
  end

  def random_data
    dip = rand(8)
    if dip < 4
      self.update email: create_email
    elsif dip > 4
      social = create_social
      self.update first_name: social.first_name, last_name: social.last_name, email: social.email
    elsif dip == 4
      # create_sms(id.to_s, 1000, station.client_mac)
    end
  end

  def self.generate_mac
    (1..6).map{"%0.2X"%rand(256)}.join("-")
  end

  def self.create_new_demo_people
    location = Location.find_or_initialize_by id: Person.demo_location ### it's a starting point
    (rand(80) + 20).times do
      person = create_person
      person.create_station
      person.random_data

      person.save
    end

    return unless location.new_record?
    location.update location_name: 'Demo Location'
  end

  def self.update_existing_demo_data
    people_count = Person.where(location_id: demo_location).size
    return unless people_count > 20

    (rand(20)).times do
      person = Person.where(location_id: demo_location).sample
      new_count = person.login_count + (rand(4) + 1)
      person.update last_seen: Time.now - rand(60 * 60 * 24).seconds, login_count: new_count
    end
  end

  def self.delete_old_demo_data
    Person.where('location_id =? AND last_seen <=?', demo_location, (Time.now - 90.days)).destroy_all
  end
end
