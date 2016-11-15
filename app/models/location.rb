class Location < ActiveRecord::Base
  has_many :events

  def self.all_values
      Location.pluck('value')
  end
end
