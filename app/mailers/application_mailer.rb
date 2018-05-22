# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'testy@test.com'
  layout 'mailer'
end
