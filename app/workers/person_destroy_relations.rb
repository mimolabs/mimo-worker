class PersonDestroyRelations
  include Sidekiq::Worker
  
  sidekiq_options retry: true

  def perform(options={})
    return unless options['location_id'].present? && options['person_id'].present?
    Person.destroy_relations(options)
  end
end