require 'rails_helper'

RSpec.describe SplashIntegration, type: :model do

  describe 'Notifying users when new boxes get imported' do
    it 'should send a message to a user if the success boxes > 0' do
      user = User.create email: Faker::Internet.email
      location = Location.create user_id: user.id
      s = SplashIntegration.create location_id: location.id

      a = s.notify_new_devices('unifi', {})
      expect(a).to eq nil

      expect { s.notify_new_devices('unifi', {success: 1}) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
