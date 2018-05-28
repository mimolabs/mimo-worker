##
## This class represents a record of a social - for example someone who logs in with Facebook, Google or Twitter.

class Social < ApplicationRecord

  include Facebook
  # after_update :update_person

  ##
  # Fetch the social profile from the designated provider
  #
  # Current only Facebook, Google and Twitter are supported.

  def fetch(opts)

  end

  ##
  # Will fetch the details from Facebook
  #
  # Returns an object which is used to create / update the social record
  #
  # It's possible to test this by getting a Facebook Access Token from the
  # graph explorer. Add to the opts as :token. Should return the requested details from Facebook. Don't ask for too many permissions and be explicit with your users.

  def fetch_facebook(opts)
    params = {
      'accessToken' => opts[:token]
    }

    details = Facebook.fetch(params)

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
    end

    if body['type'] == 'google'
      social.meta['google'] = body
    end

    if body['type'] == 'twitter'
      social.meta['twitter'] = body
    end

    social.clean_station_and_people(body) 
    social.person_id = body['person_id']

    social.save
  end

  ## 
  # Cleans up old stations and persons. 
  #
  # A user checks in via FB on one device. A station and person are created.
  # Later they checkin with a different device, same FB account.
  # We merge the details in, remove the old person and update station.

  def clean_station_and_people(body)
    if person_id && (person_id != body['person_id'])
      s = Station.find_by(person_id: body['person_id'])
      s.update_columns person_id: person_id if s.present?
      Person.find_by(id: body['person_id']).destroy
    end
  end

end
