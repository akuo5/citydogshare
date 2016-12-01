class User < ActiveRecord::Base 
  include ActiveModel::ForbiddenAttributesProtection
  
  # attr_accessor :first_name, :last_name, :location, :gender, :image, :status, :phone_number, :email, :availability, :description, :address, :zipcode, :city, :country, :is_pro
  validates :phone_number, :phone_number => {:ten_digits => true, :message => "Please enter a valid phone number"}, :allow_blank => true
  validates :zipcode, format: { with: /\d{5}/, message: "Bad format for zipcode."}, :allow_blank => true

  has_many :dogs, :dependent => :destroy
  has_many :events, :dependent => :destroy

  has_many :stars, :dependent => :destroy
  has_many :starred_dogs, through: :stars, :source => :dog

  def update_credentials(credentials)
    self.oauth_token = credentials[:token]
    self.oauth_expires_at = Time.at(credentials[:expires_at].to_i)
    self.save 
  end

  def facebook_info_update(auth)
    self.uid = auth[:uid]
    if(auth[:extra][:raw_info] != nil)
      self.gender = auth[:extra][:raw_info][:gender]
    end
    self.first_name = auth[:info][:first_name]
    self.last_name = auth[:info][:last_name]
    self.image = auth[:info][:image] + "?width=200&height=200"
    self.location = auth[:info][:location]
    self.email = auth[:info][:email]
    self.save
  end

  def full_name
    return "#{self.first_name} #{self.last_name}"
  end

  def future_events?
    # for all events, if at least one comes after yesterday, return true
    events.where("end_date > ?", 1.day.ago.midnight).pluck('end_date') != []
  end
  
  def set_pro(flag)
    self.is_pro = flag
    self.save
  end 
   
   def is_pro?
     if self.is_pro
      return true
    else
      self.set_pro(false)
      return self.is_pro
    end
   end
  
  def to_json
    return {
      :id => self.id,
      :full_name => self.full_name,
      :email => self.email,
      :status => self.status,
      :availability => self.availability, 
      :description => self.description,
      :image => self.image,
    }
  end

end
