class RecordLogin

  include Sidekiq::Worker

  def perform(opts)
    PeopleRelation.record(opts)
  end
end

