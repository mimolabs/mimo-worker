class DownloadPersonTimeline
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options retry: true

  def perform(options={})
    return unless options['person_id'].present? && options['email'].present?
    PersonTimeline.download(options)
  end
end