module PeopleRelation

  def self.stripped_email(email)
    email.split('@')[0].gsub(/[-_.]/, ' ').gsub(/[0-9]|[^\w\s]/, '')
  end

  def self.create_username(email)
    return 'Splash User' unless email.present?

    stripped = stripped_email(email)
    return stripped if stripped.length >= 5
    'Splash User'
  end

  def self.record(opts)

    ### Convert Sidekiq hash of strings to symbols because it's easier
    opts = opts.inject({}) { |memo,(k,v)| memo[k.to_sym] = v; memo }

    ### Initialize a station
    station = Station.find_or_initialize_by(
      location_id: opts[:location_id], 
      client_mac: opts[:client_mac]
    )

    ### Initialise a person
    person = Person.find_or_initialize_by(
      location_id: opts[:location_id],
      client_mac: opts[:client_mac]
    )

    opts[:type] = 'unknown'

    if opts[:email].present? && person.email.blank?
      person.email = opts[:email].downcase
      person.consented = false
      opts[:type] = 'email'
    end
   
    if person.new_record?
      username = create_username(person.email)
      spl = username.split(' ')
      person.username = username.titlecase

      person.first_name = spl[0].titlecase
      person.last_name  = spl[1].titlecase if spl.length > 1
      person.last_seen  = Time.now
      person.login_count = 1
    else
      new_count = person.login_count.to_i + 1
      person.login_count = new_count
      person.last_seen = Time.now
      # person.google_id ||= google_id
    end

    person.save

    if station.new_record? || station.person_id.blank?# || station.person_id != person.try(:id).to_s
      station.person_id = person.id
      station.save
    end

    ### Create the email 
    opts[:person_id] = person.id
    Email.create_record(opts) if opts[:email].present?

    ### records the terms agreed timeline event 
    record_terms_agreement(opts)

    ### creates the timeline
    create_timeline(opts)
    true
  end

  def self.should_terms(opts)
    opts[:consent] && ([true, 'true'].include?(opts[:consent][:terms]))
  end

  def self.calc_timestamp(opts)
    return opts[:timestamp].present? ? Time.at(opts[:timestamp]) : Time.now
  end

  def self.record_terms_agreement(opts)
    return unless should_terms(opts)

    params = {
      person_id: opts[:person_id],
      location_id: opts[:location_id],
      event: 'agreement_terms',
      created_at: calc_timestamp(opts),
      meta: {
        client_mac: opts[:client_mac]
      }
    }
    PersonTimeline.create(params)
  end

  def self.create_timeline(opts)
    params = {
      person_id: opts[:person_id],
      location_id: opts[:location_id],
      event: "sign_in_#{opts[:type]}",
      created_at: calc_timestamp(opts),
      meta: {
        client_mac: opts[:client_mac],
        email: opts[:email],
        sms: opts[:sms_number]
      }
    }
    PersonTimeline.create(params)
  end
end
