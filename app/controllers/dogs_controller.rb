class DogsController < ApplicationController

  require 'dog_form_filler'

  before_filter :current_user

  def index
    ip_zipcode = get_ip_address_zipcode
    @form_filler = DogViewHelper.new(current_user, ip_zipcode, true)
    @form_filler.update_values(params, ip_zipcode, current_user)
    @dogs = Dog.filter_by @form_filler.values
    @no_dogs = @dogs.empty?

    @zipcodes = get_zipcode_from_dogs
    @counts = get_zipcode_counts.to_json
  end

  def get_ip_address_zipcode
    # request.safe_location.postal_code
    '94704'
  end
  
  # TODO(jacensherman): Add tests for this
  def info
    id = params[:id]
    if !Dog.exists?(id)
      render :json => {
        "success" => false,
        "message" => "Dog not found"
      }
    else
      @dog = Dog.find(id)
      render :json => { 
        "success" => true,
        "message" => "Dog found",
        "dog" => @dog.to_json
      }
    end
  end
  
  # Returns all dogs that satisfy avaiable filters, which include:
  # available=true/false, more upon request
  def all_info
    filtered_dogs_hash = Dog.all.select { |dog|
      valid_dog = true
      if params[:available] == "true" && !dog.available then valid_dog = false end
      if params[:available] == "false" && dog.available then valid_dog = false end
      valid_dog
    }.map { |dog| { :name => dog.name, :id => dog.id } }
    
    render :json => {
      :success => true,
      :message => filtered_dogs_hash.size.to_s + " dog(s) found",
      :dogs => filtered_dogs_hash
    }
  end

  def new
    # @form_filler = DogViewHelper.new(nil, nil, false)
    
    @action = :create
    @method = :post
    @dog_form_values = {}
    
    unless current_user.zipcode != nil and current_user.zipcode != "" 
      flash[:notice] = "Please update your zipcode to add a dog."
      redirect_to edit_user_path(current_user)
    end
  end

  def show
    id = params[:id]
    @dog = Dog.find(id)
    @parent = User.find(@dog.user_id)
    @pictures = @dog.pictures
  end

  def create
    @dog = Dog.new(attributes_list(dog_params))
    @dog.user_id = current_user.id
    if @dog.save      
      add_multiple_pictures(@dog)
      redirect_to dogs_user_path(current_user)
    else
      flash[:notice] = @dog.errors.messages
      @dog_form_values = dog_params
      render 'new'
    end
  end

  def edit
    @dog = Dog.find(params[:id])
    if @dog.user != @current_user
      redirect_to dogs_path
    end
    @dog_form_values = @dog.to_form_hash
    @pictures = @dog.pictures
    @action = :update
    @method = :put
  end

  def update
    @form_filler = DogViewHelper.new(nil, nil, false)
    @dog = Dog.find(params[:id])
    @pictures = @dog.pictures
    if @dog.update_attributes(@form_filler.attributes_list(dog_params))
      delete_checked_pictures
      add_multiple_pictures(@dog)
      redirect_to dogs_user_path(@current_user.id)
    else
      flash[:notice] = @dog.errors.messages
      redirect_to edit_dog_path(@dog.id) 
    end
  end

  def destroy
    @dog = Dog.find(params[:id])
    @dog.photo.destroy
    @dog.delete
    redirect_to user_path(@current_user)
  end

  def get_zipcode_from_dogs
    @dogs.all.collect{|dog| dog.address}
  end

  def get_zipcode_counts
    wf = Hash.new(0)
    @zipcodes.each{|word| wf[word] += 1}
    wf
  end

  def dog_params
    params.require(:dog).keys.each do |key|
      if params[:dog][key].kind_of?(Array)
        params[:dog][key] = purge_param(params[:dog][key])
      end
    end
    params.require(:dog).permit(:name, :image, :dob, :gender, :description, 
    :motto, :fixed, :health, :comments, :contact, :availability, {:mixes => []}, 
    {:likes =>[]}, :energy_level, :size, :photo, :latitude, :longitude, :video, 
    :dob, {:personalities =>[]}, :chipped, :shots_to_date, {:barks => []})
  end

  # Removes the default "" values and any invalid value the user my try to send through
  def purge_param(check_params)
    delete_params = []
    check_params.each do |val|
      if Mix.all_values.include?(val) or Personality.all_values.include?(val) or Like.all_values.include?(val) or Bark.all_values.include?(val) then
        delete_params << val
      end
    end
    delete_params.each do |p| check_params.delete(p) end
  end
  
  def add_multiple_pictures(myDog)
    if params[:images]        
      params[:images].each { |image|
        myDog.pictures.create(image: image)
      }
    end
  end

  def delete_checked_pictures
    activated_ids = params[:activated].collect {|id| id.to_i} if params[:activated]
    seen_ids = params[:seen].collect {|id| id.to_i} if params[:seen]

    if activated_ids
      seen_ids.each do |id|          
        checked = activated_ids.include?(id)
        pic = Picture.find_by_id(id)
        pic.destroy if checked
      end
    end  
  end

  # A function to get the attribures in the proper format, has helper functions used directly below
  def attributes_list(dog_attributes)
    ## Return hash with new dog values to create new dog/update existing dog
    new_attrs = {
      :mixes => get_mix_array(dog_attributes['mixes']),
      :size => dog_attributes['size'] && dog_attributes['size'].length != 0 ? Size.find(dog_attributes['size']): nil, 
      :energy_level => dog_attributes['energy_level'] && dog_attributes['energy_level'].length != 0 ? EnergyLevel.find(dog_attributes['energy_level']) : nil, 
      :likes => get_attribute_array(dog_attributes, 'likes'),
      :personalities => get_attribute_array(dog_attributes, 'personalities'),
      :barks => get_attribute_array(dog_attributes, 'barks'),
      :dob => get_birthday(dog_attributes) }
    dog_attributes.merge(new_attrs)
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
