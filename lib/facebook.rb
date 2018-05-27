## 
## The Facebook module makes calls to the Facebook API. It's mostly for the Socials.

module Facebook

  ## 
  # Uses the Facebook Graph API to fetch a profile by using an access token.
  #
  # Returns a hash
  def self.fetch(opts)
    body = {
      access_token: opts['accessToken'],
      fields: 'id,name,email,link,first_name,last_name,gender'
    }

    url = 'https://graph.facebook.com/me/'

    conn = Faraday.new(
      url: url,
      request: { timeout: 10, open_timeout: 10 }
    )
    
    response = conn.get do |req|
      req.params = body
    end

    case response.status
    when 200
      return JSON.parse(response.body)
    end
  end

end
