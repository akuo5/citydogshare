class Event < ActiveRecord::Base
  # attr_accessible :start_date, :end_date, :time_of_day, :my_location, :dog, :description
  belongs_to :user
  has_and_belongs_to_many :dogs
  belongs_to :location

  validates :dogs, :presence => {:message => "Please select the dogs you want to share"}
  validates :location, :presence => {:message => "Please select a location"}
  validates :start_date, :presence => {:message => "Please enter a start date"}
  validates :end_date, :presence => {:message => "Please enter an end date"}
  validate :valid_start_end_dates?
  
  def valid_start_end_dates?
    errors.add(:start_date, "Start date has passed") if start_date.present? and Date.today > start_date
    errors.add(:end_date, "End date has passed") if end_date.present? and Date.today > end_date
    if start_date.present? and end_date.present?
      errors.add(:start_end_date, "Start date must be before end date") if start_date > end_date
    end
  end

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
