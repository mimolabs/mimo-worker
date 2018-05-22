# frozen_string_literal: true

class LocationDefaults
  include Sidekiq::Worker

  def perform(id)
    location = Location.find_by id: id
    location.generate_defaults
  end
end
