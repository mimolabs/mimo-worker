class Email < ApplicationRecord
  include MailChimp
  include CampaignMonitor
  include Sendgrid

  def self.create_record(opts)
    e = Email.find_or_initialize_by(
      email:        opts[:email].downcase,
      location_id:  opts[:location_id]
    )

    e.person_id = opts[:person_id]

    if opts[:external_capture] || opts[:double_opt_in] == false
      e.consented = true
    end

    send_double_opt_in = e.new_record? ? true : false
    e.save 

    return unless send_double_opt_in
    e.send_double_opt_in_email 
  end

  def send_double_opt_in_email
    code = create_doi_code

    link = ENV['MIMO_DASHBOARD_URL']
    link = "https://#{link}/#/doi/#{id}?code=#{code}"

    opts = {
      email: email,
      link: link
    }

    EmailMailer.with(opts).double_opt_in_email.deliver_now
  end

  def create_doi_code
    code = SecureRandom.hex
    REDIS.setex("doubleOptIn:#{id}", 60*60*24*7, code)
    code
  end

  def add_to_list(splash_id)
    splash = SplashPage.find_by(id: splash_id)
    return false unless splash && allowed?(splash)

    opts = {
      splash_id: splash.id,
      type: splash.newsletter_type,
      token: splash.newsletter_api_token,
      list: splash.newsletter_list_id
    }
    subscribe_newsletter(opts)
  end

  def subscribe_newsletter(opts)
    case opts[:type]
    when 2, '2' # mailchimp
      mc_subscribe(opts)
    when 3, '3' # campaign monitor
      cm_subscribe(opts)
    when 4, '4' # sendgrid
      sg_subscribe(opts)
    end
  end

  def allowed?(splash)
    splash.newsletter_active &&
      splash.newsletter_api_token && \
      splash.newsletter_list_id && \
      splash.newsletter_type > 1
  end

  ### Helpers
  def email_in_list
    puts 'Email already in that list'
    false
  end

  def location
    @email_location ||= Location.find_by id: location_id
  end
end
