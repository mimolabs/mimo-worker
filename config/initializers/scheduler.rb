require 'sidekiq'
require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    file = Rails.root.join('config', 'sidekiq_scheduler.yml')
    Sidekiq.schedule = YAML.load_file(file)
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end
