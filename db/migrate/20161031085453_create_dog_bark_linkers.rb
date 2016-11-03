class CreateDogBarkLinkers < ActiveRecord::Migration
  def change
    create_table :dog_bark_linkers do |t|
      t.integer :dog_id
      t.integer :bark_id
    end
  end
end
