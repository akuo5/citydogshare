class AddDogEvents < ActiveRecord::Migration
  def change
    create_table :dogs_events, id: false do |t|
      t.belongs_to :dog, index: true
      t.belongs_to :event, index: true
    end
  end
end
