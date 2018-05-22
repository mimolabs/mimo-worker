# frozen_string_literal: true

class Location < ApplicationRecord

  has_many :location_users, :dependent => :destroy

  def generate_defaults
    create_splash
    create_location_users
    true
  end

  def create_splash
    puts 'Creating MIMO splash page'
    s = SplashPage.new
    s.location_id = id
    s.splash_name = 'MIMO Splash'
    s.primary_access_id = 20 # default always

    # s.realm             = unique_id
    s.password            = Helpers.words
    s.default_password    = SecureRandom.hex
    s.unique_id           = SecureRandom.random_number(100000000000000)
    s.header_text         = I18n.t(:"splash.default_welcome_text", :default => "Welcome to our WiFi")
    s.info                = I18n.t(:"splash.default_info_text", :default => "This is default welcome message")
    s.address             = location_address
    s.timezone            = timezone
    s.newsletter_consent  = true

    return unless s.save
    # put back when we do the radius stuff
    # s.update_policy_groups
  end

  def create_location_users
    lu = LocationUser.find_or_initialize_by(location_id: id, user_id: user_id)
    return unless lu.new_record?
    lu.update role_id: 0
  end
end
