class ChangeAvailabilityFormat < ActiveRecord::Migration
  def up
    change_column :dogs, :availability, :boolean
  end

  def down
    change_column :dogs, :availability, :string
  end
end
