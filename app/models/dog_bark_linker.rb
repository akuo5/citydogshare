class DogBarkLinker < ActiveRecord::Base
  belongs_to :dog
  belongs_to :bark
end
