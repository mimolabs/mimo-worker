class PersonTimelineRequest
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options retry: true

  def perform(options={})
    return unless options['email'].present?
    Person.create_portal_links_email(options['email'])
  end
end