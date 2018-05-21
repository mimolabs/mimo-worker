module CampaignMonitor

  def cm_subscribe(opts)
    api_key = opts[:token].gsub(' ','')
    list = opts[:list].gsub(' ','')
    auth = {api_key: api_key}

    return email_in_list if (lists.present? && (lists.include? list))

    return false if disabled_cm(opts)

    resp = CreateSend::Subscriber.add(auth, list, email, '', [], true)
    return false if resp != email

    self.lists ||= []
    self.lists << list
    self.save
    puts 'Subscribing to CampaignMonitor'
    create_timeline(list, opts, 'cm')

    return true
  end
  
  def cm_key(id)
    "splashCmDisabled:#{id}"
  end

  def disabled_cm(opts)
    val = REDIS.get cm_key(opts[:splash_id])
    return false unless val.present?

    puts "Splash page #{opts[:splash_id]} disabled because of an issue with CM"
    return true
  end
end
