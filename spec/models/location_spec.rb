require 'rails_helper'

RSpec.describe Location, type: :model do
  describe 'location generate defaults' do
    it 'should generate the defaults for a location' do
      location = Location.create location_name: 'My Top Location'
      expect(location.generate_defaults).to eq true
      

      s = SplashPage.where(location_id: location.id)
      expect(s).to be_present
    end
  end
end
