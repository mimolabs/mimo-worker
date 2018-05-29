rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = Rails.env || 'production'

require 'sidekiq'

sidekiq_config = YAML.load(ERB.new(File.read(rails_root + '/config/redis_server.yml')).result)

Sidekiq.configure_server do |config|
  config.redis = { :host => "#{sidekiq_config[rails_env]}"}
end

Sidekiq.configure_client do |config|
  config.redis = { :host => "#{sidekiq_config[rails_env]}"}
end

schedule_file = "config/scheduler.yml"

if File.exists?(schedule_file)
  Sidekiq::Cron::Job.load_from_hash! YAML.load_file(schedule_file)
end
