class Admin < ActiveRecord::Base
  def self.is_admin?(user)
    user != nil and Admin.where(:email => user.email).exists?
  end
end
