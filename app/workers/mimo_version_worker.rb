# frozen_string_literal: true

class MimoVersionWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def perform(args={})
    MimoVersion.check
  end
end
