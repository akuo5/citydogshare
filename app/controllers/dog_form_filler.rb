class DogViewHelper

  attr_accessor :values

  DEFAULT_RADIUS = 100
  CHECKBOX_CRITERIA = [:gender, :personality, :energy_level, :size, :age, :like, :mix]
  
  def initialize(current_user, ip_zipcode, index)
    @values = {}
    @values[:mix] = index ? "All Mixes" : []
    @values[:gender] = []
    @values[:age] = []
    @values[:energy_level] = index ? [] : 1
    @values[:size] = index ? [] : 1
    @values[:radius] = DEFAULT_RADIUS
    @values[:zipcode] = current_user ? current_user.zipcode : ip_zipcode
    @values[:personality] = []
    @values[:bark] = []
    @values[:like] = []
  end

  def update_values(selected, ip_zipcode, current_user)
    CHECKBOX_CRITERIA.each {|criteria| get_checkbox_selections(selected, criteria)}
    @values[:zipcode] = update_zipcode(selected, ip_zipcode, current_user)
    @values[:radius] = selected[:radius].nil? ? DEFAULT_RADIUS : selected[:radius].to_i
  end

  def get_checkbox_selections(selected, criteria)
    @values[criteria] = selected[criteria] if selected[criteria]
  end

  def update_zipcode(selected, ip_zipcode, current_user)
    if selected[:zipcode] # Set from Params first
      @values[:zipcode] = selected[:zipcode]
    elsif current_user and current_user.zipcode # Next default to current user's zipcode
      @values[:zipcode] = current_user.zipcode
    else # Otherwise IP address zipcode
      @values[:zipcode] = ip_zipcode
    end
  end

end