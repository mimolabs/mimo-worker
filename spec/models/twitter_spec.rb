require 'rails_helper'

RSpec.describe Twitter, type: :model do
  describe 'retrieve a profile' do
    it 'should fetch a profile from twitter' do
      opts = {
        :token => 'MY-SECRET-TOKEN'
      }

      details = Twitter.fetch(opts)
      expect(details['id']).to eq 'xxx'
      expect(details['name']).to eq name
      expect(details['type']).to eq 'google'
    end
  end
end
