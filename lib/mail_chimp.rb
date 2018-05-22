module MailChimp

  def mc_url_token(token)
    token = token.split('-')
    return nil, nil if token.length != 2

    url = "https://#{token[1]}.api.mailchimp.com/3.0"
    key = token[0]
    return url, key
  end
  
  def create_timeline(list, opts, service='mailchimp')
    pt = PersonTimeline.new
    pt.location_id = location_id
    pt.event       = "#{service}_subscribe"
    pt.person_id   = person_id
    pt.meta        = { 
      list: list,
      email: email
    }
    pt.save
  end
  
  def mc_key(id)
    "splashMcDisabled:#{id}"
  end

  def mc_error(response,id)
    if response.status == 400
      puts response.body
      return
    end

    body = JSON.parse(response.body)
    REDIS.setex mc_key(id), 86400, body['detail']
    puts "Disabling splash newsletter since we have an error jim"
    mc_error_code_body(response)
    false
  end

  def mc_subscribe(opts)
    list = opts[:list].gsub(' ','')

    ### Checks if the email has already been subscribed - don't send email
    return email_in_list if (lists && (lists.include? list))

    ### Checks if the splash is disabled
    return false if disabled_mc(opts)

    token = opts[:token].gsub(' ','')
    url, key = mc_url_token(token)

    ### Disable the splash if the URL is invalid and send email
    return invalid_mc_url(opts) unless url.present?

    path = "/lists/#{list}/members"

    conn = Faraday.new(
      url: (url + path),
      request: { timeout: 10, open_timeout: 10 }
    )

    body = { email_address: opts[:email], status: 'pending' }

    response = conn.post do |req|
      req.body                      = body.to_json
      req.headers['Content-Type']   = 'application/json'
      req.headers['Authorization']  = "apikey #{key}"
      req.options.timeout           = 3
      req.options.open_timeout      = 2
    end

    case response.status
    when 200
      puts "Subscribed #{opts[:email]} to #{opts[:list]}"
      self.lists ||= []
      self.lists << list
      self.save

      create_timeline(list, opts)
      return true
    end

    return mc_error(response, opts[:splash_id])
  end
  
  def disabled_mc(opts)
    val = REDIS.get mc_key(opts[:splash_id])
    return false unless val.present?

    puts "Splash page #{opts[:splash_id]} disabled because of an issue with MC"
    return true
  end
  
  def invalid_mc_url(opts)
    REDIS.setex mc_key(opts[:splash_id]), 86400, 'Invalid API token'

    user = User.find_by id: location.try(:user_id)
    return false unless user.present?

    opts = {
      email: user.email,
      location: location,
      type: 'MailChimp'
    }

    SplashMailer.with(opts).invalid_api_token.deliver_now
    false
  end

  def mc_error_code_body(body)
    user = User.find_by id: location.try(:user_id)
    return unless user.present?

    opts = {
      email: user.email,
      location: location,
      type: 'MailChimp'
    }

    if body.present?
      opts[:url]    = body['type'] 
      opts[:error]  = body['detail'] 
    end

    SplashMailer.with(opts).generic_error.deliver_now
  end
end
