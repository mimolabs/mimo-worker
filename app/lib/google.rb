## 
## The Google module makes calls to the Google API. It's mostly for the Socials.

module Google

  ## 
  # Uses the Google API to fetch a profile by using an access token.
  #
  # Returns a hash of the person

  def self.fetch(auth)
    url   = "https://www.googleapis.com/plus/v1/people/me"
    token = auth[:token]
    conn = Faraday.new(:url => url)
    conn.headers['Authorization'] = "Bearer #{token}"
    response = conn.get
    case response.status
    when 200
      details = JSON.parse(response.body)
      details['type'] = 'google'
      details
    end
  end
end
