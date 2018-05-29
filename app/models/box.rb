# frozen_string_literal: true

class Box < ApplicationRecord
  before_validation :clean_mac, on: %i[create update]
  validates_uniqueness_of :mac_address
  validates_presence_of :location_id, on: :create

  private

  def clean_mac
    return unless attribute_present?(:mac_address)
    self.mac_address = Helpers.clean_mac(mac_address)
  end
end
