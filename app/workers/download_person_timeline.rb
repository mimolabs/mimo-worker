class DownloadPersonTimeline
  include Sidekiq::Worker
  sidekiq_options retry: true

  def perform(options={})
    return unless options['person_id'].present? && options['email'].present?
    Person.download_person_data(options)
  end
end
