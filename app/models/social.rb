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

  def self.create_facebook(body)
    social = Social.find_or_initialize_by(
      location_id: body['location_id'],
      facebook_id: body['id']
    )

    social.meta ||= {}
    social.email = body['email']
    social.meta['facebook'] = body
    social.save
  end

end
