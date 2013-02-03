class Item < ActiveRecord::Base
  attr_accessible :name, :position
  
  has_many :slides
end
