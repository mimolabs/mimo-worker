class RecordLogin

  include Sidekiq::Worker

  def perform(opts)
    puts opts
  end
end

