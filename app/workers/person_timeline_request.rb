class PersonTimelineRequest
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options retry: true

  def perform(options={})
    return unless options['email'].present?
    Person.create_timeline(options['email'])
  end
end