# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!

require 'factory_bot'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods

  FactoryBot.find_definitions

  if ENV['CI']
    Rails.logger.info 'Not filtering any tests!'
  else
    config.filter_run focus: true
    config.filter_run_excluding :slow unless ENV["SLOW_SPECS"]
    config.run_all_when_everything_filtered = true
  end
end
