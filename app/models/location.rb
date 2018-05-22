# frozen_string_literal: true

class Location < ApplicationRecord
  def generate_defaults

    create_splash
    true
  end

  def create_splash(nid)
    puts 'Creating MIMO splash page'
    s = SplashPage.new
    s.location_id = id
    s.networks = [nid]
    s.splash_name = 'MIMO Splash'
    s.primary_access_id = 20 # mimo 

    s.realm             = unique_id
    s.password          ||= Helpers.words
    s.default_password  = SecureRandom.hex
    s.unique_id         ||= SecureRandom.random_number(100000000000000)
    s.header_text       ||= "Welcome to our WiFi"
    s.info              ||= "This is default welcome message"
    s.website           ||= location_website
    s.address           ||= location_address
    s.timezone          = timezone

    return unless s.save
    # put back when we do the radius stuff
    # s.update_policy_groups
  end
end
