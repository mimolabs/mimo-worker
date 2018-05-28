##
# The UniFi module will import / update devices automatically from the UniFi controller.
# It also updates the stats so we can display to the end-user

module Unifi

  ##
  # Gets the credentials from the UniFi controller and returns and object that can be used to interact
  # with the UniFi API
  def unifi_get_credentials # validate account
    opts = { username: username, password: password }
    response = post_unifi('/login', opts)

    return false unless response.present?
    case response.status
    when 200
      cookies = response.env[:response_headers]['set-cookie']
      return unifi_cookies_to_object(cookies)
    else
      puts 'Oh no!'
      false
    end
  end

  # def import_unifi_boxes
  #   puts 'Importing UniFi boxes'
  #   boxes = unifi_fetch_boxes

  #   return {} unless boxes.present?

  #   success = 0
  #   failed = []

  #   boxes.each do |box|
  #     mac = Helpers.clean_mac box['mac']
  #     puts "Importing #{mac}"
  #     n = process_import_boxes(box, 'unifi')
  #     n.save ? (success += 1) : (failed << mac)
  #   end

  #   obj =  { success: success, failed: failed }
  #   return obj
  # end

  def unifi_fetch_boxes
    cookies = unifi_get_credentials
    return unless cookies.present?

    site_name = metadata['unifi_site_name'] || 'default'
    path = "/s/#{site_name}/stat/device"
    resp = get_unifi(path, {}, cookies)

    return unless resp.present?

    case resp.status
    when 200
      return JSON.parse(resp.body)['data']
    end
  end

  ## 
  # Creates a POST request against the UniFi controller and returns the response body.
  # It requires the cookes which are set using unifi_get_credentials

  def post_unifi(path, opts={}, cookies=nil)
    conn = Faraday.new(
      url: host + "/api#{path}",
      ssl: { verify: false }
    )
    resp = conn.post do |req|
      req.body                      = opts.to_json if opts.present?
      req.headers['Content-Type']   = 'application/json'
      req.headers['User-Agent']     = 'Get MIMO!'
      if cookies.present?
        req.headers['cookie']         = cookies["raw"]
        req.headers['csrf_token']     = cookies["csrf_token"]
      end
      req.options.timeout           = 3
      req.options.open_timeout      = 2
    end
    # log(resp)
    return resp
  # rescue => e
  #   Rails.logger.info e
  #   # log({status: 0}, opts)
  #   false
  end

  private

  def unifi_cookies_to_object(cookies)
    obj = {}

    m = cookies.match(/unifises=(.*?);/)
    obj['cookie'] = m[1]

    m = cookies.match(/csrf_token=(.*?);/)
    obj['csrf_token'] = m[1]
    obj['raw'] = cookies

    return obj
  end
end
