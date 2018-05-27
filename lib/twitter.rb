## 
## The Twitter module makes calls to the Twitter API. It's mostly for the Socials.

module Twitter

  ## 
  # Uses the Twitter API to fetch a profile by using an access token.
  #
  # Returns a hash of the person

  def self.fetch(auth)
    bearer = get_twitter_bearer
    return unless bearer
    url = "https://api.twitter.com/1.1/users/show.json\?screen_name=#{auth[:screen_name]}"
    resp = Faraday.new(url: url).get do |req|
      req.options.timeout           = 3
      req.options.open_timeout      = 2
      req.headers['Authorization']  = "Bearer #{bearer}"
      req.headers['Content-Type'] = 'application/json'
    end
    case resp.status
    when 200
      details = JSON.parse(resp.body)
      details['type'] = 'twitter'
      details
    end
  end
  
  def self.get_twitter_bearer
    credentials = ENV['TWITTER_CONSUMER_KEY'] + ":" + ENV['TWITTER_CONSUMER_SECRET']
    credentials = Base64.strict_encode64(credentials)

    url = 'https://api.twitter.com/oauth2/token'
    resp = Faraday.new(url: url).post do |req|
      req.options.timeout           = 3
      req.options.open_timeout      = 2
      req.headers['Authorization']  = "Basic #{credentials}"
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.body = URI.encode_www_form({ grant_type: 'client_credentials' })
    end
    case resp.status
    when 200
      body = JSON.parse(resp.body)
      return body['access_token']
    end
  end
end
