require 'rails_helper'

RSpec.describe Location, type: :model do
  describe 'location generate defaults' do
    it 'should generate the defaults for a location' do
      location = Location.create location_name: 'My Top Location', user_id: 100000
      expect(location.generate_defaults).to eq true

      s = SplashPage.where(location_id: location.id).first
      expect(s.password).to be_present
      expect(s.default_password).to be_present
      expect(s.unique_id).to be_present
      expect(s.newsletter_consent).to eq true
      expect(s.info).to eq 'This is default welcome message'

      lus = LocationUser.where(location_id: location.id)
      expect(lus.size).to eq 1
      expect(lus.first.role_id).to eq 0
    end
  end
end
