# TODO(angelakuo)
class Event < ActiveRecord::Base
  # attr_accessible :start_date, :end_date, :time_of_day, :my_location, :dog, :description
  belongs_to :user
  has_and_belongs_to_many :dogs
  belongs_to :location

  validates :dogs, :presence => {:message => "Please select the dogs you want to share"}
  validates :location, :presence => {:message => "Please select a location"}
  validates :start_date, :presence => {:message => "Please enter a start date"}
  validate :valid_start_end_dates?
  validate :no_overlap
  
  scope :upcoming, -> { where("start_date >= ?", Date.today) }
  
  def valid_start_end_dates?
    errors.add(:start_date, "Start date has passed") if start_date.present? and Date.today > start_date
    errors.add(:end_date, "End date has passed") if end_date.present? and Date.today > end_date
    if start_date.present? and end_date.present?
      errors.add(:start_end_date, "Start date must be before end date") if start_date > end_date
    end
  end
  
  def no_overlap
    names = []
    dogs.each do |dog|
      dog.events.each do |event|
        if overlap?(event) and event.id != self.id
          names << dog.name if !names.include?(dog.name)
        end
      end
    end
    if !names.empty?
      message = names.length > 1 ? "have overlapping events" : "has an overlapping event"
      errors.add(:event_overlap, "#{names.to_sentence} #{message}")
    end
  end
  
  def overlap? (event)
    self.end_date = self.start_date if self.end_date.nil?
    self.start_date <= event.end_date and self.end_date >= event.start_date
  end

  def readable_location
    self.location.value
  end
  
  def readable_dogs
    self.dogs.map{ |d| d.name }.join(', ')
  end
  
  def readable_filled
    self.filled ? "Yes" : "No"
  end

  def to_form_hash
    form_hash = {
      :start_date => self.start_date,
      :end_date => self.end_date, 
      :location_id => self.location_id,
      :dogs => self.dogs.map{ |d| d.id },
      :description => self.description,
      :filled => self.filled
    }
    form_hash[:start_date] = form_hash[:start_date].strftime("%d %B, %Y") if form_hash[:start_date]
    form_hash[:end_date] = form_hash[:end_date].strftime("%d %B, %Y") if form_hash[:end_date]

    return form_hash
  end
  
  # END_DATE IS NOT ACCURATE FOR THE CALENDAR
  def to_fc_json
    { :id => self.id,
      :title => self.readable_dogs,
      :start => "#{self.start_date.iso8601}",
      :end => "#{self.end_date.tomorrow.iso8601}",
      :color => self.filled ? "#00C853" : "#0277bd" }
  end
end
