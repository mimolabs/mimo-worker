##
## The PeopleRelation module creates the linked models including socials, emails, stations etc.
## It's called whenever someone successfully logs in. 

module PeopleRelation

  ##
  # Returns a potential username by stripping the email out.

  def self.stripped_email(email)
    email.split('@')[0].gsub(/[-_.]/, ' ').gsub(/[0-9]|[^\w\s]/, '')
  end

  ##
  # Creates a username from an email. If no interesting name is available, it returns 'Splash User'
  def self.create_username(email)
    return 'Splash User' unless email.present?

    stripped = stripped_email(email)
    return stripped if stripped.length >= 5
    'Splash User'
  end

  ##
  # This creates all the relations between people, socials, emails, stations.
  # 
  # It also creates the timeline events for the login and the terms and conditions.
  #

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

      if opts[:external_capture] || opts[:double_opt_in] == false
        person.consented = true
      end
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
    opts[:person_id] = person.id

    if station.new_record? || station.person_id.blank?# || station.person_id != person.try(:id).to_s
      station.person_id = person.id
      station.save
    end

    ### Create the email 
    opts[:person_id] = person.id
    if opts[:email].present?
      opts[:type] = 'email'
      Email.create_record(opts) 
    end

    ### Create the OTP
    if opts[:otp] == 'true'
      opts[:type] = 'sms'
      number = create_sms(opts)
      opts[:sms_number] = number 
    end

    ### Record the social = fetches from FB
    if opts[:social_type].present?
      opts[:type] = opts[:social_type]
      Social.fetch(opts)
    end

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

  def self.create_sms(opts)
    sms = Sms.find_by(
      location_id: opts[:location_id], 
      client_mac: opts[:client_mac]
    )
    return unless sms.present?

    return unless sms.update(person_id: opts[:person_id])

    sms.try(:number)
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
