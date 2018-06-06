# frozen_string_literal: true

class GenerateDemoData
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def perform(args={})
    Person.create_demo_data
  end
end
