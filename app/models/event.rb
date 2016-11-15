class Event < ActiveRecord::Base
  # attr_accessible :start_date, :end_date, :time_of_day, :my_location, :dog, :description
  belongs_to :user
  has_and_belongs_to_many :dogs
  belongs_to :location

  validates :start_date, :presence => {:message => "Please enter a valid start date"}
  validates :end_date, :presence => {:message => "Please enter a valid end date"}
  validates :location, :presence => {:message => "Please select a valid location"}
  validates :dogs, :presence => {:message => "Please select the dogs you want to share"}

  def readable_location
    self.location.value
  end
  
  def readable_dogs
    self.dogs.map{ |d| d.name }.join(', ')
  end

  def to_form_hash
    return {
      :start_date => self.start_date,
      :end_date => self.end_date,
      :location_id => self.location_id,
      :dogs => self.dogs.map{ |d| d.id },
      :description => self.description
    }
  end
end
