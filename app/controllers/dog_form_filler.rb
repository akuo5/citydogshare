class DogViewHelper

  attr_accessor :values

  DEFAULT_RADIUS = 100
  CHECKBOX_CRITERIA = [:gender, :personality, :energy_level, :size, :age, :like]

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
    @values[:like] = []
  end

  def update_values(selected, ip_zipcode, current_user)
    CHECKBOX_CRITERIA.each {|criteria| get_checkbox_selections(selected, criteria)}
    @values[:mix] = selected[:mix] if selected[:mix]
    @values[:zipcode] = update_zipcode(selected, ip_zipcode, current_user)
    @values[:radius] = selected[:radius].nil? ? DEFAULT_RADIUS : selected[:radius].to_i

  end

  def get_checkbox_selections(selected, criteria)
    @values[criteria] = selected[criteria].keys if selected[criteria]
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

  def attributes_list(dog_attributes)
    # Set form fields with new dog's information
    @values[:personality] = dog_attributes['personalities'] ? get_attribute_array(dog_attributes, 'personalities')  : []
    
    @values[:like] = dog_attributes['likes'] ? get_attribute_array(dog_attributes, 'likes') : []
    @values[:size] = dog_attributes['size']
    @values[:energy_level] = dog_attributes['energy_level']
    @values[:mix] = dog_attributes['mixes'].split(',')
    # byebug

    ## Return hash with new dog values to create new dog/update existing dog
    new_attrs = {
      :mixes => get_mix_array(dog_attributes['mixes']),
      :size => dog_attributes['size'].length == 0 ? nil : Size.find(dog_attributes['size']), 
      :energy_level => dog_attributes['energy_level'].length == 0 ? nil : EnergyLevel.find(dog_attributes['energy_level']), 
      :likes => get_attribute_array(dog_attributes, 'likes'),
      :personalities => get_attribute_array(dog_attributes, 'personalities'),
      :dob => get_birthday(dog_attributes) }
    dog_attributes.merge(new_attrs)
  end

  def dog_view_update(dog)
    ## Fills edit form with dog's current values
    @dog = Dog.find(dog)
    @values[:like] = @dog.readable_likes
    @values[:personality] = @dog.readable_personalities
    @values[:size] = @dog.size_id
    @values[:energy_level] = @dog.energy_level_id
    @values[:mix] = @dog.mixes.pluck(:value)

  end

  def get_birthday(dog_attributes)
    year = dog_attributes['dob'].to_i
    DateTime.new(year, 1, 1)
  end

  def get_mix_array(mix_arr)
    mix_arr.blank? ? [] : mix_arr.map{ |m| Mix.find_by_value(m) }
  end

  def get_attribute_array(attributes, trait)
    if attributes[trait] != nil
      model_class = trait.classify.constantize
      attributes[trait].each.map { |thing| model_class.find_by_value(thing) }
    else
      return []
    end
  end



end