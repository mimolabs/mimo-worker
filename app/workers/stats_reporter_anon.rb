# frozen_string_literal: true

class StatsReporterAnon
  include Sidekiq::Worker
  def perform(args={})
    Settings.anonymous_stats
  end
end
