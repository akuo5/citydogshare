class AddFilledToEvents < ActiveRecord::Migration
  def change
    add_column :events, :filled, :boolean
  end
end
