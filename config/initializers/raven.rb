### Actually this won't work until the settings are populated, which is rubbish.
# What can we do to trigger this from the front - set a job??

Raven.configure do |config|
  return if Rails.env.test?
  id = ENV['MIMO_SETTINGS_ID'] || Settings.first.try(:unique_id)
  return unless id.present?
  if Rails.env.development?
    config.dsn = "http://mimo:user@127.0.0.1:3000/#{id}"
  else
    config.dsn = "https://mimo:user@stats-sink.oh-mimo.com/#{id}"
  end
end
