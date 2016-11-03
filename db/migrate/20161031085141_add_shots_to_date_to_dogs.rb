class AddShotsToDateToDogs < ActiveRecord::Migration
  def change
    add_column :dogs, :shots_to_date, :boolean
  end
end
