# frozen_string_literal: true

class PersonTimeline < ApplicationRecord

  def self.download(options)
  #   timeline_events = find_items(options)
  #   return false unless timeline_events.present?
  #   csvs = [create_csv(timeline_events), create_people_csv(options), create_email_csv(options), create_social_csv(options), create_sms_csv(options)]
  #   send_timeline(options['person_id'], csvs.compact, options['email'])
  # end
  #
  # def self.find_items(options)
  #   where(person_id: options['person_id']).order(created_at: :desc).to_a
  # end
  #
  # def self.create_csv(events)
  #   file_name = "timeline_#{events[0].person_id}_#{SecureRandom.hex(5)}.csv"
  #   CSV.open("/tmp/#{file_name}", 'wb') do |csv|
  #     csv << %w(Date Event From To Subject Content Delivered_At State Opens Clicks Mac_Address Login_Email)
  #     events.each do |event|
  #       csv << [event.created_at, event.event, event.from, event.to, event.subject, event.content, event.delivered_at, event.state, event.opens, event.clicks, event.client_mac, event.login_email]
  #     end
  #   end
  #   file_name
  # end
  #
  # def self.create_people_csv(options)
  #   person = Person.find_by(id: options['person_id'])
  #   return unless person.present?
  #   file_name = "person_#{options['person_id']}_#{SecureRandom.hex(5)}.csv"
  #   CSV.open("/tmp/#{file_name}", 'wb') do |csv|
  #     csv << %w(First_Name Last_Name Username Email Login_Count Mac_Address Created Last_Seen Google_ID Unsubscribed)
  #     csv << [person.first_name, person.last_name, person.username, person.email, person.login_count, person.client_mac, person.created_at, person.last_seen, person.google_id, person.unsubscribed]
  #   end
  #   file_name
  # end
  #
  # def self.create_email_csv(options)
  #   emails = Email.where(person_id: options['person_id'])
  #   return unless emails.present?
  #   file_name = "emails_#{options['person_id']}_#{SecureRandom.hex(5)}.csv"
  #   CSV.open("/tmp/#{file_name}", 'wb') do |csv|
  #     csv << %w(Email Active Created_At Macs Active Added Unsubscribed)
  #     emails.each do |email|
  #       csv << [email.email, email.active, email.created_at, email.macs, email.active, email.added, email.unsubscribed]
  #     end
  #   end
  #   file_name
  # end
  #
  # def self.create_social_csv(options)
  #   socials = Social.where(person_id: options['person_id'])
  #   return unless socials.present?
  #   file_name = "socials_#{options['person_id']}_#{SecureRandom.hex(5)}.csv"
  #   CSV.open("/tmp/#{file_name}", 'wb') do |csv|
  #     csv << %w(First Last Date Gender Networks Email Twitter_Username Twitter_ID Facebook_ID Google_ID)
  #     socials.each do |social|
  #       csv << [social.firstName, social.lastName, social.updated_at, social.gender, social.email, social.tw_url, social.tw_screen_name, social.twitter_id, social.facebookId, social.googleId]
  #     end
  #   end
  #   file_name
  # end
  #
  # def self.create_sms_csv(options)
  #   sms = Sms.where(person_id: options['person_id'])
  #   return unless sms.present?
  #   file_name = "sms_#{options['person_id']}_#{SecureRandom.hex(5)}.csv"
  #   CSV.open("/tmp/#{file_name}", 'wb') do |csv|
  #     csv << %w(Created_At Number Mac)
  #     sms.each do |sms|
  #       csv << [sms.created_at, sms.number, sms.client_mac]
  #     end
  #   end
  #   file_name
  # end
  #
  # def self.send_timeline(person_id, csvs, email)
  #   zip = create_zip(csvs, person_id)
  #   clean_up(csvs, zip) if Mailer.send_timeline(zip, email)
  # end
  #
  # def self.create_zip(csvs, person_id)
  #   Zip::File.open("/tmp/#{person_id}.zip", Zip::File::CREATE) do |zip|
  #     csvs.each do |csv|
  #       zip.add csv, "/tmp/#{csv}"
  #     end
  #   end
  #   "#{person_id}.zip"
  # end
  #
  # def self.clean_up(csvs, zip)
  #   File.delete("/tmp/#{zip}") if File.exist?("/tmp/#{zip}")
  #   csvs.each do |csv|
  #     File.delete("/tmp/#{csv}") if File.exist?("/tmp/#{csv}")
  #   end
  end

end
