class EventsController < ApplicationController

  before_filter :current_user

  def index
    @events = @current_user.events.upcoming.sort { |a,b| a.start_date <=> b.start_date }
  end

  # ONLY for fullcalendar, displays end_date 1 day ahead so don't use this as
  # an accurate source of information
  def fc_info
    events_info = []
    @current_user.events.each do |event|
      events_info << event.to_fc_json
    end
    render :json => events_info.to_json
  end

  # redirects to event page because we don't have a specific event info page
  def show
    redirect_to events_path
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
    @event = Event.new(params_hash)
    @event.dogs << params["event"]["dogs"].map { |id| Dog.where(:id => id) }
    @event.user_id = @current_user.id
    @event_form_values = @event.to_form_hash
    
    if @event.save
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
    if @event.update_attributes!(params_hash) and not params["event"]["dogs"].empty?
      if params["fc_update"].nil?
        @event.dogs.clear
        @event.dogs << params["event"]["dogs"].map { |id| Dog.where(:id => id) }
        redirect_to events_path
      else
        refresh
      end
    else
      flash[:notice] = @event.errors.messages
      if params["fc_update"].nil?
        redirect_to edit_event_path(params[:id])
      else
        refresh
      end
    end
  end
  
  def refresh
    respond_to do |format|
      format.js { render js: 'window.location.href = "/events";' }
    end
  end

  def params_hash
    # FullCalendar updates end_date off by 1 day
    if params["fc_update"]
      attributes = 
      { :start_date => params["event"]["start_date"],
        :end_date => Date.iso8601(params["event"]["end_date"]).yesterday
      }
    else
      attributes = 
      { :start_date => params["event"]["start_date"],
        :end_date => params["event"]["end_date"].empty? ? params["event"]["start_date"] : params["event"]["end_date"],
        :filled => params["event"]["filled"] == "Filled" ? true : false,
        :location_id => params["event"]["location"],
        :description => params["event"]["description"]
      }
    end
    return attributes
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:notice] = "Your event has been deleted."
    redirect_to events_path
  end
end