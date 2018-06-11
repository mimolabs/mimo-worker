class Settings < ApplicationRecord

  ##
  # Sends anonymous stats back to MIMO every night

  def self.anonymous_stats
    settings = Settings.first
    return unless settings.present?

    # run migration from API first
    # true if settings.anon = true

    opts = {}

    opts[:id]       = settings.unique_id
    opts[:boxes]    = Box.all.size
    opts[:people]   = Person.all.size
    opts[:emails]   = Email.all.size
    opts[:social]   = Social.all.size
    opts[:station]  = Station.all.size

    host = ENV['MIMO_ANON_STATS'] || 'https://anon-stats.ldn-01.oh-mimo.com/v1'

    conn = Faraday.new(
      url: host + '/' + settings.unique_id,
      request: { timeout: 2, open_timeout: 2 }
    )

    response = conn.post do |req|
      req.body                      = opts.to_json
      req.headers['Content-Type']   = 'application/json'
    end
    puts "Stats sent, code: #{response.status}"
  rescue => e
    print e
  end
end
