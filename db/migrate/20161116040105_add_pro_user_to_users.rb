class AddProUserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_pro, :boolean, :null => false, :default => false
  end
end
