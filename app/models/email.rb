class Email < ApplicationRecord
  include MailChimp
  include CampaignMonitor

  def add_to_list(splash_id)
    splash = SplashPage.find_by(id: splash_id)
    return false unless splash && allowed?(splash)
   
    opts = { 
      splash_id: splash.id,
      type: splash.newsletter_type,
      token: splash.newsletter_api_token,
      list: splash.newsletter_list_id,
    }
    subscribe_newsletter(opts)
  end

  def subscribe_newsletter(opts)
    case opts[:type]
    when 2, '2' # mailchimp
      mc_subscribe(opts)
    when 3, '3' # campaign monitor
      cm_subscribe(opts)
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
    puts "Email already in that list"
    false
  end

end
