# frozen_string_literal: true

class WipeEventLogs
  include Sidekiq::Worker
  def perform(args={})
    EventLog.where('created_at <=?', Time.now - 30.days).destroy_all
  end
end
