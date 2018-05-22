class Email < ApplicationRecord
  include MailChimp
  include CampaignMonitor
  include Sendgrid

  def self.create_record(opts)
    e = Email.find_or_initialize_by(
      email:        opts[:email],
      location_id:  opts[:location_id]
    )
    # e.splash_id ||= opts['splash_id']
    e.person_id = opts[:person_id]
    # e.add_to_list(opts['splash_id'], opts['mergedata'])
    # e.client_id = e.client(opts['mac'])                  if e.client_id.blank?
    # e.record_event #unless e.persisted?
    # if (opts[:external_capture] && opts[:mimo] == false) || opts['double_opt_in'] == false
    #   e.consented = true
    # elsif e.new_record?
    #   send_doi_email(opts, e.id.to_s)
    # end
    e.save if e.new_record?
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
>>>>>>> 7b8a9cd6b5cb5e03030a121f81c366673751ffdf
  end
end
