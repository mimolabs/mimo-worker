module MimoVersion 

  def self.check
    settings = Settings.first
    return unless settings.present?
    url   = ENV['MIMO_UPGRADES_URL'] || "https://updates.ldn-01.oh-mimo.com/v1/updates"
    conn = Faraday.new(:url => url + '/#{settings.unique_id}')
    response = conn.get
    case response.status
    when 200
      REDIS.set 'newVersion#beta', Time.now.to_s
      puts response.body
    end
  end
end
