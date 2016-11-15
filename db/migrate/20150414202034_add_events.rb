class AddEvents < ActiveRecord::Migration
  def change
  	create_table :events do |t|
  		t.datetime :start_date
  		t.datetime :end_date
  		t.string :time_of_day
  		t.string :location_id
  		t.integer :dog_id
  	end
  	
    create_table :locations do |t|
        t.string :value
    end
  end
end
