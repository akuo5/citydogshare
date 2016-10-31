class AddChippedToDogs < ActiveRecord::Migration
  def change
    add_column :dogs, :chipped, :boolean
  end
end
