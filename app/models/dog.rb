class Dog < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  # attr_accessible :name, :image, :dob, :gender, :description, :motto, :fixed, :health, :comments, :contact, :availability, :mixes, :likes, :energy_level, :size, :personalities, :photo, :latitude, :longitude, :video

  scope :has_gender, lambda {|genders| filter_gender(genders)}
  scope :has_personalities, lambda {|personalities| filter_personality(personalities)}
  scope :has_likes, lambda {|likes| filter_like(likes)}
  scope :has_mix, lambda {|mix| filter_mix(mix)}
  scope :has_bark, lambda {|bark| filter_bark(bark)}
  scope :has_energy_level, lambda {|energy_levels| filter_energy_level(energy_levels)}
  scope :has_size, lambda {|sizes| filter_size(sizes)}
  scope :in_age_range, lambda {|age_query| filter_age(age_query)}

  belongs_to :user
  belongs_to :energy_level
  belongs_to :size
  
  has_many :stars, :dependent => :destroy
  has_many :dog_mix_linkers
  has_many :dog_like_linkers
  has_many :dog_personality_linkers
  has_many :dog_bark_linkers
  has_many :mixes, :through => :dog_mix_linkers
  has_many :likes, :through => :dog_like_linkers
  has_many :personalities, :through => :dog_personality_linkers
  has_many :barks, :through => :dog_bark_linkers
  has_and_belongs_to_many :events

  geocoded_by :address

  validates :name, :presence => {:message => "Please enter a name"}
  validates :gender, :presence => {:message => "Please select a gender"}
  validates :size, :presence => {:message => "Please select a size"}
  validates :mixes, :presence => {:message => "Please select the mix"}
  validates :personalities, :presence => {:message => "Please select at least one personality"}
  validates_inclusion_of :fixed, in: [true, false], :message => "Please select a response for fix"
  validates_inclusion_of :chipped, in: [true, false], :message => "Please select a response for chipped"
  validate :validate_dob
  validate :validate_availability

  #paperclip avatar
  has_attached_file :photo, 
                    :styles => { :small    => '150x',
                                 :medium   => '300x',
                                 :large    => '600x'},
                    :default_url => "",
                    :storage => :s3,
                    :bucket => ENV["AWS_BUCKET_NAME"],
                    :path => "/:class/:images/:id/:style/:basename.:extension"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  #paperclip dog multiple pictures
  has_many :pictures, :dependent => :destroy

  after_validation :geocode

  ## Attribute Access Functions
  def validate_dob
    errors.add(:dob, "Dog's birthday can't be in the future.") if (!dob.nil? and dob > Date.today)
  end
  
  def validate_availability
    errors.add(:availability, "AWWWW BUSTED! Please select a proper availability.") if (!availability.nil? and availability != "Available" and availability != "Unavailable")
  end
  
  def age
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def age_caption
    y = age
    out = "< 1 year old" if y == 0
    out = "1 year old" if y == 1
    out = "#{y} years old" if y > 1
    out = "" if dob.year == 0
    out
  end

  def tags
    readable_personalities.join(", ") 
  end

  def owner
    User.find(self.user_id)
  end
  
  def readable_size
    self.size.value.capitalize
  end
  
  def readable_energy_level
    self.energy_level ? self.energy_level.value.capitalize : ""
  end

  def readable_mixes
    self.mixes.map {|m| m.value}
  end

  def readable_likes
    self.likes.map {|l| l.value.capitalize}
  end

  def readable_personalities
    self.personalities.map {|p| p.value.capitalize}
  end

  def readable_barks
    self.barks.map {|b| b.value.capitalize}
  end
  
  def readable_fixed
    self.fixed ? "Yes" : "No"
  end
  
  def readable_chipped
    self.chipped ? "Yes" : "No"
  end
  
  def readable_shots_to_date
    if !self.shots_to_date.nil?
      self.shots_to_date ? "Yes" : "No"
    else
      "Unknown"
    end
  end

  def address
    user = self.owner
    "#{user.zipcode}"
  end

  def youtube_id
    video.split(%r{v=|&})[1]
  end
  
  def available
    self.availability && self.availability != "Unavailable" ? true : false
  end
  
  def to_form_hash
    return {
      :name => self.name,
      :dob => self.dob.year,
      :size => self.size.id,
      :gender => self.gender,
      :mixes => self.readable_mixes,
      :personalities => self.readable_personalities.map {|val| val.downcase},
      :energy_level => self.energy_level ? self.energy_level.id : 0,
      :likes => self.readable_likes.map {|val| val.downcase},
      :barks => self.readable_barks,
      :fixed => self.fixed,
      :chipped => self.chipped,
      :shots_to_date => self.shots_to_date,
      :health => self.health,
      :status => self.motto,
      :description => self.description,
      :availability => self.availability,
    }
  end
  
  def to_json
    return {
      :id => self.id,
      :name => self.name,
      :dob => self.dob.year,
      :size => self.readable_size,
      :gender => self.gender,
      :mixes => self.readable_mixes,
      :personalities => self.readable_personalities,
      :energy_level => self.readable_energy_level,
      :likes => self.readable_likes,
      :barks => self.readable_barks,
      :fixed => self.fixed,
      :chipped => self.chipped,
      :shots_to_date => self.shots_to_date,
      :health => self.health,
      :status => self.motto,
      :description => self.description,
      :available => self.available,
      :parent => self.user_id
    }
  end

  ## Attribute Possible Values Functions

  def self.genders
    ["Male", "Female"]
  end

  def self.age_ranges
    ["0-2 years", "2-4 years", "5-8 years", "9+ years"]
  end

  ## Filter Functions for Search Results (Dog Index Page)

  def self.filter_gender(genders)
    where("gender" => genders) unless genders.empty?
  end

  def self.filter_personality(personalities)
    joins(:personalities).where("personalities.value" => personalities) unless personalities.empty?
  end

  def self.filter_like(likes)
    joins(:likes).where("likes.value" => likes) unless likes.empty?
  end

  def self.filter_mix(mix)
    joins(:mixes).where("mixes.value" => mix) unless mix == "All Mixes"
  end
  
  def self.filter_bark(barks)
    joins(:barks).where("barks.value" => bark) unless barks.empty?
  end

  def self.filter_energy_level(energy_levels)
    joins(:energy_level).where("energy_levels.value" => energy_levels) unless energy_levels.empty?
  end

  def self.filter_size(sizes)
    joins(:size).where("sizes.value" => sizes) unless sizes.empty?
  end
  
  def self.filter_age(age_query)
    where(age_query) unless age_query == ""
  end

  def self.convert_age_ranges_to_dob_query(age_ranges_indices)
    age_ranges = [[0, 2], [2, 4], [5, 8], [9, 30]]
    age_query = ""
    age_ranges_indices.each do |i|
        base = get_base(i.to_i, age_ranges)
        if i.to_i < age_ranges_indices.length - 1
          age_query += (base + " OR ")
        else
          age_query += base
        end
    end
    age_query
  end

  def self.get_base(i, ranges)
    first = (Time.now - ranges[i][1].years).strftime "%Y-%m-%d %H:%M:%S"
    second = (Time.now - ranges[i][0].years).strftime "%Y-%m-%d %H:%M:%S"
    base = %Q[("dogs"."dob" BETWEEN '#{first}' AND '#{second}')]
  end

  def self.filter_by(criteria)
    dogs = Dog.near(criteria[:zipcode], criteria[:radius])
              .has_mix(criteria[:mix])
              .has_size(criteria[:size])
              .has_likes(criteria[:like])
              .has_personalities(criteria[:personality])
              .has_bark(criteria[:bark])
              .has_gender(criteria[:gender])
              .has_energy_level(criteria[:energy_level])
              .in_age_range(convert_age_ranges_to_dob_query(criteria[:age]))
  end
  
  # Event Methods
  def future_events?
    # for all events, if at least one comes after yesterday, return true
    self.events.where("end_date > ?", 1.day.ago.midnight).pluck('end_date') != []
  end

  def future_events
    self.events.where("end_date > ?", 1.day.ago.midnight).order("start_date ASC")
  end

end
