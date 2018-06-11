# frozen_string_literal: true

class Sms < ApplicationRecord
  def self.csv_file_name(person_id)
    "sms_#{person_id}_#{SecureRandom.hex(5)}.csv"
  end

  def self.csv_headings
    %w(ID Created_At Number Person_ID)
  end

  def csv_data
    [id, created_at, number, person_id]
  end
end
