require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MimoWorker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
        
    config.autoload_paths << "#{Rails.root}/lib"
    config.autoload_paths += %W(#{config.root}/app/workers)
    config.active_job.queue_adapter = :sidekiq
  end
end
