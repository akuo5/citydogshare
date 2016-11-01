class Bark < ActiveRecord::Base
  has_many :dog_bark_linkers
  has_many :dogs, :through => :dog_bark_linkers

  def self.all_values
      Bark.pluck('value')
  end
end
