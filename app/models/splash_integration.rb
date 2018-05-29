class SplashIntegration < ApplicationRecord
  include Unifi

  def process_import_boxes(box,type)
    return Box.new(
      mac_address:      box['mac'],
      description:      box['name'],
      location_id:      location_id,
      machine_type:     type
    )
  end

  ##
  # Sends a message to the account owner if there are new devices detected
  #

  def notify_new_devices(type, obj={})
    return unless obj[:success].to_i > 0

    opts = {}
    
    details = splash_integration_user_email
    return unless details.present?

    opts = {
      type: type,
      email: details[0],
      location_name: details[1],
      device_count: obj[:success]
    }

    UserMailer.with(opts).new_devices_imported.deliver_now
    true
  end

  def splash_integration_user_email
    location = Location.find_by id: location_id
    return unless location.present?

    user = User.find_by id: location.user_id
    return [user.email, location.location_name]
  end
end
