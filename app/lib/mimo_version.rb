module MimoVersion 

  def self.check
    settings = Settings.first
    return unless settings.present?
    url   = "https://updates.ldn-01.oh-mimo.com/v1/#{settings.unique_id}"
    conn = Faraday.new(:url => url)
    response = conn.get
    case response.status
    when 200
      REDIS.set 'newVersion#beta', Time.now.to_s
      puts response.body
    end
  end
end
