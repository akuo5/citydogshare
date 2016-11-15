class EventsController < ApplicationController

  before_filter :current_user

  def index
    @events = []
    @dogs = @current_user.dogs
  end

  def show
    id = params[:id]
    @event = Event.find(id)
    redirect_to user_path(@event.user_id)
  end

  def new
    @action = :create
    @method = :post
    @event_form_values = {}
    unless !@current_user.dogs.empty?
      flash[:notice] = "Please create a dog to share"
      redirect_to dogs_user_path(current_user.id)
    end
  end

  def create
    params_hash = 
    { :start_date => params["event"]["start_date"],
      :end_date => params["event"]["end_date"],
      :location_id => params["event"]["location"],
      :description => params["event"]["description"]
    }
    @event = Event.new(params_hash)
    @dogs = @current_user.dogs
    @event.dogs << params["event"]["dogs"].map { |id| Dog.where(:id => id) }
    @event.user_id = @current_user.id
    @event_form_values = @event.to_form_hash

    if @event.save and not @event.dogs.empty?
      redirect_to events_path
    else
      flash[:notice] = @event.errors.messages
      render 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
    @event_form_values = @event.to_form_hash
    @action = :update
    @method = :put
  end

  def update
    @event = Event.find(params[:id])
    params_hash = 
    { :start_date => params["event"]["start_date"],
      :end_date => params["event"]["end_date"],
      :location_id => params["event"]["location"],
      :description => params["event"]["description"]
    }
    @event.dogs.clear
    @event.dogs << params["event"]["dogs"].map { |id| Dog.where(:id => id) }
    if @event.update_attributes(params_hash) and not @event.dogs.empty?
      redirect_to events_path
    else
      flash[:notice] = @event.errors.messages
      redirect_to edit_event_path(params[:id])
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.delete
    flash[:notice] = "Your event has been deleted."
    redirect_to events_path
  end
end