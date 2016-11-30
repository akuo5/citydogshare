class AddProUserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_pro, :boolean, :default => false
  end
end
