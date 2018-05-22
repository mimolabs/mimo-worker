class Email < ApplicationRecord

  def self.create_record(opts)
    e = Email.find_or_initialize_by(
      email:        opts[:email],
      location_id:  opts[:location_id]
    )
    # e.splash_id ||= opts['splash_id']
    e.person_id = opts[:person_id]
    # e.add_to_list(opts['splash_id'], opts['mergedata'])
    # e.client_id = e.client(opts['mac'])                  if e.client_id.blank?
    # e.record_event #unless e.persisted?
    # if (opts[:external_capture] && opts[:mimo] == false) || opts['double_opt_in'] == false
    #   e.consented = true
    # elsif e.new_record?
    #   send_doi_email(opts, e.id.to_s)
    # end
    e.save if e.new_record?
  end
end
