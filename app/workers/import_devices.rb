# frozen_string_literal: true

class ImportDevices
  include Sidekiq::Worker
  def perform(args={})
    SplashIntegration.where(integration_type: 'unifi', active: true).map { |si| si.import }
  end
end
