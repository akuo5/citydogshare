class RemoveDogIdFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :dog_id
  end
end
