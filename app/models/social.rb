##
## This class represents a record of a social - for example someone who logs in with Facebook, Google or Twitter.

class Social < ApplicationRecord

  include Facebook
  after_create :update_person
  after_update :update_person

  ##
  # Fetch the social profile from the designated provider
  #
  # Current only Facebook, Google and Twitter are supported.

  def self.fetch(opts)
    details = fetch_details(opts)
    return unless details
    create_social(details)
  end

  def self.fetch_details(opts)
    case opts[:social_type]
    when 'tw'
      Social.fetch_twitter(opts)
    when 'fb'
      Social.fetch_facebook(opts)
    when 'google'
      Social.fetch_google(opts)
    end
  end

  ##
  # Will fetch the details from Facebook
  #
  # Returns an object which is used to create / update the social record
  #
  # It's possible to test this by getting a Facebook Access Token from the
  # graph explorer. Add to the opts as :token. Should return the requested details from Facebook. Don't ask for too many permissions and be explicit with your users.

  def self.fetch_facebook(opts)
    params = {
      'accessToken' => opts[:token]
    }

    details = Facebook.fetch(params)
    return unless details.present?

    details["location_id"]  = opts[:location_id]
    details['client_mac']   = opts[:client_mac]
    details['newsletter']   = opts[:newsletter]
    details['person_id']    = opts[:person_id]

    return details
  end

  ##
  # Will fetch the details from Twitter
  #
  # Returns an object which is used to create / update the social record
  #
  # Requires the twitter env vars to be set. Needs the :screen_name parameter in the opts 
  # in order to fetch the profile
  
  def self.fetch_twitter(opts)
    details = Twitter.fetch(opts)
    return unless details.present?

    details["location_id"]  = opts[:location_id]
    details['client_mac']   = opts[:client_mac]
    details['newsletter']   = opts[:newsletter]
    details['person_id']    = opts[:person_id]

    return details
  end

  ##
  # Will fetch the details from Google
  #
  # Returns an object which is used to create / update the social record
  #
  
  def self.fetch_google(opts)
    opts = {
      token: auth[:token],
    }

    details = Google.fetch(opts)
    return unless details.present?

    details["location_id"]  = opts[:location_id]
    details['client_mac']   = opts[:client_mac]
    details['newsletter']   = opts[:newsletter]
    details['person_id']    = opts[:person_id]

    return details
  end

  def self.create_social(body)
    opts = {}
    opts[:location_id] = body['location_id']
    
    if body['type'] == 'facebook'
      opts[:facebook_id] = body['id']
    end

    if body['type'] == 'google'
      opts[:google_id] = body['id']
    end

    if body['type'] == 'twitter'
      opts[:twitter_id] = body['id_str']
    end

    social = Social.find_or_initialize_by(opts)

    social.meta ||= {}
    social.email = body['email']

    if body['type'] == 'facebook'
      social.meta['facebook'] = body
      social.first_name ||= body['first_name']
      social.last_name  ||= body['last_name']
    end

    if body['type'] == 'google'
      social.meta['google'] = body
      social.first_name ||= body['name']['givenName']
      social.last_name  ||= body['name']['familyName']
    end

    if body['type'] == 'twitter'
      social.meta['twitter'] = body
    end

    social.clean_station_and_people(body) 
    social.person_id = body['person_id']

    ### Increment the checkins
    social.new_record? ? (social.checkins = 1) : (social.checkins += 1)

    social.save
  end

  ## 
  # Cleans up old stations and persons. 
  #
  # A user checks in via FB on one device. A station and person are created.
  # Later they checkin with a different device, same FB account.
  # We merge the details in, remove the old person and update station.

  def clean_station_and_people(body)
    return if !person_id || (person_id == body['person_id'])
    s = Station.find_by(person_id: body['person_id'])
    s.update_columns person_id: person_id if s.present?
    Person.find_by(id: body['person_id']).destroy
  end

  private

  ##
  # Updates the person so we have the icons and email etc
  #
  # Nice for the list of people if we know who's logged in with what etc.
  # Also helps the first name / last name confusion.

  def update_person
    person = Person.find_by(id: person_id)
    return unless person

    # person.username ||= "#{firstName.to_s} #{lastName.to_s}"
    person.email ||= email if email.present?
    if person.first_name.blank? || person.first_name == 'Splash'
      person.first_name = first_name
    end
    if person.last_name.blank? || person.last_name == 'User'
      person.last_name = last_name
    end

    person.facebook = true if facebook_id
    person.google   = true if google_id
    person.twitter  = true if twitter_id
    person.save
  end

end
