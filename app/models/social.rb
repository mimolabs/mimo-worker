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

  def fetch_facebook(opts)
    params = {
      'accessToken' => opts[:token]
    }

    details = Facebook.fetch(params)

    details["location_id"]  = location_id
    details['client_mac']   = opts[:client_mac]
    details['newsletter']   = opts[:newsletter]
    details['person_id']    = opts[:person_id]

    return details
  end

end
