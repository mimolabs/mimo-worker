module Sendgrid
  
  def add_sg_recipient(opts)
    url = "https://api.sendgrid.com/v3/contactdb/recipients"
    conn = Faraday.new(url: url)
    sg_opts = [{email: email}]
    response = conn.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization']  = "Bearer #{opts[:token]}"
      req.body = sg_opts.to_json
    end
    if response.status == 201
      return JSON.parse(response.body)["persisted_recipients"][0]
    end

    # puts JSON.parse(response.body)["errors"][0]["message"]
    return sg_error(response, opts[:splash_id])
  end

  def sg_subscribe(opts)

    return email_in_list if (lists.present? && (lists.include? opts[:list]))

    ### SendGrid disabled, don't continue
    return false if disabled_sg(opts)

    ### Check the recipient can be added
    recipient_id = add_sg_recipient(opts)
    return false unless recipient_id

    url = "https://api.sendgrid.com/v3/contactdb/lists/#{opts[:list]}/recipients/#{recipient_id}"
    conn = Faraday.new(url: url)
    response = conn.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization']  = "Bearer #{opts[:token]}"
    end

    if response.status == 201
      self.lists ||= []
      self.lists << opts[:list]
      self.save
      create_timeline(opts[:list], opts, 'sendgrid')
      return true
    end

    puts JSON.parse(response.body)["errors"][0]["message"]
    return sg_error(response, opts[:splash_id])
  end
  
  def sg_key(id)
    "splashSgDisabled:#{id}"
  end

  def disabled_sg(opts)
    val = REDIS.get sg_key(opts[:splash_id])
    return false unless val.present?

    puts "Splash page #{opts[:splash_id]} disabled because of an issue with SG"
    return true
  end

  def sg_invalid_api_token
    user = User.find_by id: location.try(:user_id)
    return unless user.present?

    SplashMailer.with(
      email: user.email,
      location: location,
      type: 'SendGrid'
    )
      .invalid_api_token
      .deliver_now
  end

  def sg_error(response,id)
    if response.status == 401
      sg_invalid_api_token

      message = 'Invalid API token'
      REDIS.setex sg_key(id), 86400, message
    end

    if ['400','403','404'].include?(response.status.try(:to_s))
      puts "Disabling splash newsletter since we have an error jim"
      message = JSON.parse(response.body)["errors"][0]["message"]
      REDIS.setex sg_key(id), 86400, message
    end

    send_sg_error(sg_error_code_body(response))
  end
  
  def send_sg_error(body)
    puts 'Should send SG error!'
  end
  
  def sg_error_code_body(response)
    # return 'Hey,<br><br>There was an error with your Sendgrid settings. Please check your splash settings.' unless response.present?

    # message = JSON.parse(response.body)["errors"][0]["message"]

    # body =
    #   "Hey,<br><br>There's been an error with your Sendgrid settings for a splash page in #{location.try(:location_name) || 'unknown location'}:<br><br>"+
    #   "#{message}.<br><br>"+
    #   "Update your splash page accordingly. No emails will be added until you resolve this error.<br><br>Thanks!"

    # return body
  end
end
